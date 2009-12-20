require 'scraper'

class MelbourneScraper < Scraper
  def applications(date)
    formatted_date = "#{date.day}/#{date.month}/#{date.year}"
    url = "http://ex.melbourne.vic.gov.au/icompasweb/picker.asp?std=#{formatted_date}&end=#{formatted_date}"
    comment_url = "http://www.melbourne.vic.gov.au/AboutCouncil/ContactUs/Pages/ContactUs.aspx"
    
    page = agent.get(url)
    applications = []
    if page.at('table')
      page.at('table').search('tr').each_slice(4) do |rows|
        address = rows[1].search('th')[1].inner_text.strip
        application_id = rows[3].search('td')[0].inner_text.strip
        info_url = extract_relative_url(rows[3].search('td')[0])
        description = rows[3].search('td')[1].inner_text.strip
        date_received = rows[3].search('td')[2].inner_text.strip
        applications << DevelopmentApplication.new(
          :address => address,
          :application_id => application_id,
          :info_url => info_url,
          :comment_url => comment_url,
          :description => description,
          :date_received => date_received)
      end
    end
    applications
  end
end