require 'info_master_scraper'

class KuringgaiScraper < InfoMasterScraper
  def applications(date)
    base_url = "http://datracking.kmc.nsw.gov.au/datracking/modules/applicationmaster/default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 1).map do |values|
      da = DevelopmentApplication.new(
        :application_id => extract_application_id(values[1]),
        :date_received => extract_date_received(values[2]),
        :address => extract_address(values[3]),
        :description => extract_description(values[3])
      )
      
      application_number = da.application_id
      application_year=""
      
      da.info_url = "#{base_url}?page=found&7=#{application_number}&8=#{application_year}"
      da.comment_url = da.info_url
      da
    end
  end
end