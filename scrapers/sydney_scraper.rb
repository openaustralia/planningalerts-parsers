require 'scraper'

class SydneyScraper < Scraper
  def applications(date)
    url = "http://www.cityofsydney.nsw.gov.au/Development/DAsOnExhibition/DAExhibition.asp"
    page = agent.get(url)
    page.search('#main-content > table').map do |app|
      address = app.search('tr')[0].at('th > strong > a').inner_text.strip
      info_url = extract_relative_url(app.search('tr')[0])

      paras = app.search('tr')[1].at('td').search('p')
      line = paras[0].inner_text
      
      # Being a little sneeky here. Removing bits of the text that we don't want
      paras[0].at('strong').remove
      paras[1].at('a').remove
      paras[2].at('strong').remove

      DevelopmentApplication.new(
        :info_url => info_url,
        :comment_url => info_url,
        :address => address,
        :application_id => paras[0].inner_text,
        :description => paras[1].inner_text,
        :on_notice_to => paras[2].inner_text)
    end
  end
end