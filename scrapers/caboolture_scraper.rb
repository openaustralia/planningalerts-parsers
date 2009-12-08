require 'info_master_scraper'

class CabooltureScraper < InfoMasterScraper
  def planning_authority_name; "Caboolture District, Moreton Bay Regional Council, QLD"; end
  def planning_authority_short_name; "Caboolture"; end
  
  def applications(date)
    base_url = "http://pdonline.caboolture.qld.gov.au/modules/applicationmaster/default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 1).map do |values|
      address_description = values[3].inner_text.split(/[\r\n]/).map{|s| s.strip}

      da = DevelopmentApplication.new(:application_id => values[1].inner_html.strip,
        :date_received => values[2].inner_html.strip,
        :address => address_description[2..3].join(', ') + ", QLD",
        :description =>  address_description[5])

      # Generate the info link by creating a search. More reliable since we don't depend on a key that could change
      # Because InfoMaster doesn't generate URLs for development applications that appear to be persistent.
      if da.application_id =~ /CDE-(\d{4})\/(\d{4})/
        application_number = $~[1]
        application_year = $~[2]
      else
        raise "Unexpected form for application_id: #{application_id}"
      end
      da.info_url = "#{base_url}?page=found&7=#{application_number}&8=#{application_year}"
      da.comment_url = email_url("idasclo@caboolture.qld.gov.au",
        "Development Application Enquiry: #{da.application_id} - Code Assessment", "")
      da
    end
  end
end