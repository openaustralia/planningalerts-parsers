require 'info_master_scraper'

class PineRiversScraper < InfoMasterScraper
  def extract_date_received(html)
    inner(html)
  end
  
  def extract_application_id(html)
    inner(html)
  end
  
  def inner(html)
    html.inner_html.strip
  end
  
  def state
    "QLD"
  end
  
  def split_lines(html)
    html.inner_text.split(/[\r\n]/).map{|s| s.strip}
  end
  
  def extract_address(html)
    (split_lines(html)[2..-3] + [state]).join(', ')
  end
  
  def extract_description(html)
    split_lines(html).last
  end
  
  def applications(date)
    base_url = "http://pdonline-pinerivers.moretonbay.qld.gov.au/modules/applicationmaster/default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 2).map do |values|
      da = DevelopmentApplication.new(
        :application_id => extract_application_id(values[1]),
        :date_received => extract_date_received(values[2]),
        :address => extract_address(values[3]),
        :description => extract_description(values[3]))
      if da.application_id =~ /^(\d+)\/(\d+)\//
        application_year, application_number = $~[1..2]
      else
        raise "Unexpected form for application_id: #{da.application_id}"
      end
      
      da.info_url = "#{base_url}?page=found&7=#{application_number}&8=#{application_year}"
      da.comment_url = email_url("developmentservices@pinerivers.qld.gov.au", "Development Application Enquiry: #{da.application_id} - #{da.description}", "")
      da
    end
  end
end