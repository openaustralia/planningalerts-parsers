require 'scraper'

class PortenfScraper < Scraper

  RECENT_7DAYS_APPS_URL = 'https://ecouncil.portenf.sa.gov.au/T1PRWebPROD/eProperty/P1/eTrack/eTrackApplicationSearchResults.aspx?Field=S&Period=L7&r=PAE.P1.WEBGUEST&f=$P1.ETR.SEARCH.SL7'
  APP_LINK = %{https://ecouncil.portenf.sa.gov.au/T1PRWebPROD/eProperty/P1/eTrack/eTrackApplicationDetails.aspx?r=PAE.P1.WEBGUEST&f=$P1.ETR.APPDET.VIW&ApplicationId=%s}

  def applications(date)
    agent.user_agent_alias = 'Mac Safari'
    page = agent.get(RECENT_7DAYS_APPS_URL)
    @applications = []
    grab_applications
    while navigate_to_next_page
      grab_applications
    end
    @applications
  end

  def grab_applications
    app_rows.each do |app_row|
      application_id = app_row.at('.//input/@value|./td[1]/a').text
      info_url = APP_LINK % application_id
      description = app_row.at('td[3]').text
      address = app_row.at('td[4]').text
      date_received = app_row.at('td[2]').text.split('/').reverse.join('-')
      @applications << DevelopmentApplication.new(
        :address => address,
        :description => description,
        :application_id => application_id,
        :info_url => info_url,
        :date_received => date_received)
    end
  end

  def next_page_link
    agent.page.at('//tr[contains(@class, "pagerRow")]/td/table//td[span]/following-sibling::td//input')
  end

  def next_button
    link = next_page_link and button = main_form.button_with(:name => link[:name], :value => link[:value])
  end

  def main_form
    agent.page.form_with(:id => 'aspnetForm')
  end

  def navigate_to_next_page
    if main_form and button = next_button
      main_form.submit(button)
    end
  end

  def app_rows
    agent.page.search('//table[contains(@id, "WebGridTabularView")]/tr[contains(@class, "normalRow") or contains(@class, "alternateRow")]')
  end
end
