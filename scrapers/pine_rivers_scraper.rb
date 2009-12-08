require 'info_master_scraper'

class PineRiversScraper < InfoMasterScraper
  def planning_authority_name; "Pine Rivers District, Moreton Bay Regional Council, QLD"; end
  def planning_authority_short_name; "Pine Rivers"; end
  
  def applications(date)
    base_url = "http://pdonline-pinerivers.moretonbay.qld.gov.au/modules/applicationmaster/default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 2).map do |values|
      address_description = values[3].inner_text.split(/[\r\n]/).map{|s| s.strip}

      da = DevelopmentApplication.new(:application_id => values[1].inner_html.strip,
        :date_received => values[2].inner_html.strip,
        :address => address_description[2..-3].join(', ') + ", QLD",
        :description => address_description[-1])
      if da.application_id =~ /^(\d+)\/(\d+)\//
        application_year, application_number = $~[1..2]
      else
        raise "Unexpected form for application_id: #{da.application_id}"
      end
      
      da.info_url = "#{base_url}?page=found&7=#{application_number}&8=#{application_year}"
      da.comment_url = email_url("developmentservices@pinerivers.qld.gov.au", "Development Application Enquiry: #{da.application_id} - #{da.description}", "")
      da
    end
  end
end