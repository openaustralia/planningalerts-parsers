require 'info_master_scraper'

class WyongScraper < InfoMasterScraper
  def applications(date)
    base_path = "http://wsconline.wyong.nsw.gov.au/applicationtracking/modules/applicationmaster/"
    base_url = base_path + "default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 1).map do |values|
      
      #Example description column in applications listing:
      #NUM ROAD SUBURB STATE POSTCODE
      #DESCRIPTION TEXT

      da = DevelopmentApplication.new(
        :application_id => extract_application_id(values[1]),
        :date_received => extract_date_received(values[2]),
        :address => extract_address_without_state(values[3]), #state is already in address
        :description => extract_description(values[3])
      )
      
      application_number = da.application_id
      application_year=""
      
      da.info_url = URI.escape(base_path + extract_info_url(values[0]))
      da.comment_url = da.info_url
      da
    end
  end
end