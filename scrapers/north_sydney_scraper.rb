require 'info_master_scraper'

class NorthSydneyScraper < InfoMasterScraper
  def applications(date)
    base_path = "http://masterview.northsydney.nsw.gov.au/Modules/applicationmaster/"
    base_url = base_path + "default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 1).map do |values|
      
      #Example description column in applications listing:
      #NUM ROAD, SUBURB
      #NUM ROAD, SUBURB
      #NUM ROAD, SUBURB
      #...
      #DESCRIPTION TEXT
      #Applicant: ...
      
      #The address takes up arbitary lines often it is repeated like above, often
      #it like, 12; 1/12; 2/12 or 24; 24A; 24B

      da = DevelopmentApplication.new(
        :application_id => extract_application_id(values[1]),
        :date_received => extract_date_received(values[2]),
        :address => extract_address(values[3],0..0), #just take the first one on the list
        :description => simplify_whitespace(extract_description(values[3],-2..-2))
      )
      
      application_number = da.application_id
      application_year=""
      
      da.info_url = URI.escape(base_path + extract_info_url(values[0]))
      da.comment_url = da.info_url
      da
    end
  end
end