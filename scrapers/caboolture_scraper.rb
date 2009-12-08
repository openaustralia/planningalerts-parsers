require 'info_master_scraper'

class CabooltureScraper < InfoMasterScraper
  def applications(date)
    base_url = "http://pdonline.caboolture.qld.gov.au/modules/applicationmaster/default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 1).map do |values|
      da = DevelopmentApplication.new(
        :application_id => extract_application_id(values[1]),
        :date_received => extract_date_received(values[2]),
        :address => extract_address(values[3]),
        :description =>  extract_description(values[3]))

      # Generate the info link by creating a search. More reliable since we don't depend on a key that could change
      # Because InfoMaster doesn't generate URLs for development applications that appear to be persistent.
      if da.application_id =~ /CDE-(\d{4})\/(\d{4})/
        application_number, application_year = $~[1..2]
      else
        raise "Unexpected form for application_id: #{da.application_id}"
      end
      da.info_url = "#{base_url}?page=found&7=#{application_number}&8=#{application_year}"
      da.comment_url = email_url("idasclo@caboolture.qld.gov.au",
        "Development Application Enquiry: #{da.application_id} - Code Assessment")
      da
    end
  end
end