require 'info_master_scraper'

class PineRiversScraper < InfoMasterScraper
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
      da.comment_url = da.info_url
      da
    end
  end
end