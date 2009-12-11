require 'scraper'

class SydneyScraper < Scraper
  def applications(date)
    url = "http://www.cityofsydney.nsw.gov.au/Development/DAsOnExhibition/DAExhibition.asp"
    page = agent.get(url)
    page.search('#main-content > table').map do |app|
      address = app.search('tr')[0].at('th > strong > a').inner_text.strip
      info_url = extract_relative_url(app.search('tr')[0])
      line = app.search('tr')[1].at('td').search('p')[0].inner_text
      application_id_para = app.search('tr')[1].at('td').search('p')[0]
      application_id_para.at('strong').remove
      application_id = application_id_para.inner_text
      description_para = app.search('tr')[1].at('td').search('p')[1]
      # Remove unnecessary link which contains text that isn't part of the description
      description_para.at('a').remove
      description = description_para.inner_text
      on_notice_to_para = app.search('tr')[1].at('td').search('p')[2]
      on_notice_to_para.at('strong').remove
      on_notice_to = on_notice_to_para.inner_text
      DevelopmentApplication.new(
        :info_url => info_url,
        :comment_url => info_url,
        :address => address,
        :application_id => application_id,
        :description => description,
        :on_notice_to => on_notice_to)
    end
  end
end