require 'info_master_scraper'

class LoganScraper < InfoMasterScraper
  def applications(date)
    base_url = "http://pdonline.logan.qld.gov.au/modules/applicationmaster/default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 1, 'span#_ctl4_lblData').map do |values|
      da = DevelopmentApplication.new(
        :application_id => extract_application_id(values[1]),
        :date_received => extract_date_received(values[2]),
        :address => extract_address_without_state(values[3]),
        :description => extract_description(values[3], 1..1))
    
        if da.application_id =~ /^[A-Z]+-(\d+)\/(\d+)/
          application_number, application_year = $~[1..2]
        else
          raise "Unexpected form for application_id: #{da.application_id}"
        end
      # The search below can return multiple results but when you use the longer form of the application number
      # (for example BW-179 instead of 179) there is an error message displayed in the app about an XLS transform
      # or some such nonsense. Nice.
      da.info_url = "#{base_url}?page=found&7=#{application_number}&8=#{application_year}"
      da.comment_url = da.info_url
      da
    end
  end
end