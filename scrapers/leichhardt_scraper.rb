require 'info_master_scraper'

class LeichhardtScraper < InfoMasterScraper
  def applications(date)
    base_path = "http://210.9.33.126/DATracking/modules/applicationmaster/"
    base_url = base_path + "default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 1).map do |values|
      
      #Example description column in applications listing:
      #NUM ROAD SUBURB STATE POSTCODE
      #DESCRIPTION TEXT
      #Applicant: ...
      
      da = DevelopmentApplication.new(
        :application_id => extract_application_id(values[1]),
        :date_received => extract_date_received(values[2]),
        :address => extract_address_without_state(values[3]), #state is already in the address text
        :description => extract_description(values[3],1..1) #col 3 line 1
      )
      
      application_number = da.application_id
      application_year=""
      
      da.info_url = URI.escape(base_path + extract_info_url(values[0]))
      da.comment_url = da.info_url
      da
    end
  end
end