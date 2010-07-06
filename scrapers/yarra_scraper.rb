require 'scraper'

class YarraScraper < Scraper
  def extract_table_data(table)
    headers = table.search('th').map{|t| t.inner_html.strip}
    data = []
    table.search('tr').each do |row|
      values = row.search('td').map{|t| t.inner_html.strip}
      unless values.empty?
        # Make a map from headers to values in each row
        map = {}
        values.each_index do |i|
          map[headers[i]] = values[i]
        end
        data << map
      end
    end
    data
  end
  
  def applications(date)
    url = "http://www.yarracity.vic.gov.au/Planning/Statutory%20Planning/PlanQuery.asp"
    comment_url = "http://www.yarracity.vic.gov.au/Planning/"
    page = agent.post(url, "Status" => "C", "Flag" => "2")
    data = extract_table_data(page.at('table'))
    # Clean up weird characters at the end
    data.map do |row|
      row.each do |k,v|
        row[k] = v[0..-2].strip
      end
      row
    end
    data.map do |row|
      DevelopmentApplication.new(
        :on_notice_from => row["Advert Date"],
        :application_id => row["Application Number"],
        :description => row["Description"],
        :address => row["Property Address"],
        :date_received => row["Date Received"],
        # Can't link to a development application directly. So, linking to search page
        :info_url => url, 
        :comment_url => comment_url
      )
    end
  end
end
