require 'scraper'

class ParramattaScraper < Scraper
  def applications(date)
    # TODO: comment_url is not populated as it would require going to
    # each DA's page and getting an email address of the council officer
    # assigned to the particular DA. Yes, that's right, email address
  
    # Get the dumb agree page
    formatted_date = "#{date.day}/#{date.month}/#{date.year}"
    url = "http://eservices.parracity.nsw.gov.au/applicationtracking/modules/DATracking/default.aspx?page=found&1=#{formatted_date}&2=#{formatted_date}"
    page = agent.get(url)
    
    # Click the agree button
    form = page.form_with(:name => "frmMasterView")
    page = form.submit(form.button_with(:name => "_ctl1:AgreeBtn")) if form
    
    # Now get the real page
    page = agent.get(url)
    
    page.search('tr.tableLine').map do |app|
        DevelopmentApplication.new(
            :application_id => simplify_whitespace(app.search('td.tableLine')[1].inner_html),
            :description => app.search('td.tableLine')[3].inner_html.split('<br>')[1],
            :date_received => app.search('td.tableLine')[2].inner_html,
            :address => simplify_whitespace(app.search('td[4]').inner_html.split('<br>')[0]),
            # You have to click through dumb agree page so this just leads to the main page
            :info_url => extract_relative_url(app),
            :comment_url => extract_relative_url(app))
    end
  end
end
