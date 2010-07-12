require 'info_master_scraper'

class KogarahScraper < InfoMasterScraper
  def applications(date)
    base_path = "http://www2.kogarah.nsw.gov.au/datracking/modules/applicationmaster/"
    base_url = base_path + "default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 1).map do |values|
      
      #Example description column in applications listing:
      #DESCRIPTION TEXT
      #NUM ROAD , SUBURB
      
      da = DevelopmentApplication.new(
        :application_id => extract_application_id(values[1]),
        :date_received => extract_date_received(values[2]),
        :address => extract_address(values[3],-1..-1),
        :description => extract_description(values[3],0..0)
      )
      
      application_number = da.application_id
      application_year=""
      
      da.info_url = URI.escape(base_path + extract_info_url(values[0]))
      da.comment_url = da.info_url
      da
    end
  end
end