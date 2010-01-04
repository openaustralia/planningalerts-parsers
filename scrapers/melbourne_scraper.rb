require 'scraper'

class MelbourneScraper < Scraper
  def applications(date)
    formatted_date = "#{date.day}/#{date.month}/#{date.year}"
    base_url = "http://ex.melbourne.vic.gov.au/icompasweb/picker.asp"
    url = "#{base_url}?std=#{formatted_date}&end=#{formatted_date}"
    comment_url = "http://www.melbourne.vic.gov.au/AboutCouncil/ContactUs/Pages/ContactUs.aspx"
    
    page = agent.get(url)
    applications = []
    # TODO: Doesn't currently handle days when there are a large number of
    # applications that run over several pages
    if page.at('table')
      table_rows = page.at('table').search('tr')
      # If only a single entry is returned it displays that entry in a more detailed format. Check for this
      if table_rows.size == 11
        da = DevelopmentApplication.new(
          :application_id => table_rows[0].search('td')[1].inner_text.strip,
          :date_received => table_rows[1].search('td')[1].inner_text.strip,
          :address => table_rows[2].search('td')[1].inner_text.strip,
          :description => table_rows[4].search('td')[1].inner_text.strip,
          :comment_url => comment_url)
        da.info_url = "#{base_url}?permit=#{da.application_id}"
        applications << da
      else
        table_rows.each_slice(4) do |rows|
          info_url = extract_relative_url(rows[3].search('td')[0])
          da = DevelopmentApplication.new(
            :address => rows[1].search('th')[1].inner_text.strip,
            :application_id => rows[3].search('td')[0].inner_text.strip,
            :description => rows[3].search('td')[1].inner_text.strip,
            :date_received => rows[3].search('td')[2].inner_text.strip,
            :comment_url => comment_url)
          da.info_url = "#{base_url}?permit=#{da.application_id}"
          applications << da
        end
      end
    end
    applications
  end
end