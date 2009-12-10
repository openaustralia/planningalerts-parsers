$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'info_master_scraper'

class GoldCoastScraper < InfoMasterScraper
  def applications(date)
    base_url = "http://pdonline.goldcoast.qld.gov.au/masterview/modules/applicationmaster/default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 1, 'span#_ctl3_lblData').map do |values|
      da = DevelopmentApplication.new(
        :application_id => extract_application_id(values[1]),
        :description => extract_description(values[3], 1..-1),
        :address => extract_address(values[3]),
        :date_received => extract_date_received(values[2]))

      if da.application_id =~ /([A-Z]+)(\d+)/
        application_type, application_number = $~[1..2]
      else
        raise "Unexpected form for application_id: #{da.application_id}"
      end
      da.info_url = "#{base_url}?page=found&4a=#{application_type}&7=#{application_number}"
      da.comment_url = da.info_url
      da
    end
  end
end
