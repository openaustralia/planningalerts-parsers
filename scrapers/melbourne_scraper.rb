require 'scraper'

class MelbourneScraper < Scraper
  
  BASE_URL = "http://ex.melbourne.vic.gov.au/icompasweb/picker.asp"
  COMMENT_URL = "http://www.melbourne.vic.gov.au/BuildingandPlanning/Planning/planningpermits/Pages/Objecting.aspx"
  
  def extract_applications_from_page(page)
    applications = []
    if page.at('table')
      table_rows = page.at('table').search('tr')
      # If only a single entry is returned it displays that entry in a
      # more detailed format, e.g. 2011-06-21 & 2011-05-11. Check for this
      if table_rows.size == 10
        da = DevelopmentApplication.new(
          :application_id => table_rows[0].search('td')[1].inner_text.strip,
          :date_received => table_rows[1].search('td')[1].inner_text.strip,
          :address => table_rows[2].search('td')[1].inner_text.strip,
          :description => table_rows[4].search('td')[1].inner_text.strip,
          :comment_url => COMMENT_URL)
        da.info_url = "#{BASE_URL}?permit=#{da.application_id}"
        applications << da
      else
        address = nil
        table_rows.each do |rows|
          # Skip empty rows
          if rows.search('td')[0]
            case rows.search('td')[0].inner_text.strip
            when ""
              # This is an address row
              address = rows.search('th')[1].inner_text.strip
            when "Permit Number"
              # skip row
            else
              values = rows.search('td').map{|t| t.inner_text.strip}
              da = DevelopmentApplication.new(
                :address => address,
                :application_id => values[0],
                :description => values[1],
                :date_received => values[2],
                :comment_url => COMMENT_URL)
              da.info_url = "#{BASE_URL}?permit=#{da.application_id}"
              applications << da
            end
          end
        end
      end
    end
    applications
  end
  
  def applications(date)
    formatted_date = "#{date.day}/#{date.month}/#{date.year}"
    url = "#{BASE_URL}?std=#{formatted_date}&end=#{formatted_date}"
    
    page = agent.get(url)
    applications = []
    begin
      applications += extract_applications_from_page(page)
      next_link = page.link_with(:text => /next/i)
      page = agent.click(next_link) if next_link
    end while next_link
    applications
  end
end
