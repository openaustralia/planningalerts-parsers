require 'info_master_scraper'

class NoosaScraper < InfoMasterScraper
  def applications(date)
    base_url = "http://rrif.noosa.qld.gov.au/masterviewpublic/modules/applicationmaster/default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 1, 'span#_ctl3_lblData').map do |values|
      da = DevelopmentApplication.new(
        :application_id => extract_application_id(values[1]),
        :date_received => extract_date_received(values[2]),
        :address => extract_address(values[3], -1..-1),
        :description => extract_description(values[3], 0..0)
      )  
      if da.application_id =~ /^(\d+) \/ (\w+)/
        application_year, application_number = $~[1..2]
      else
        raise "Unexpected form for application_id: #{da.application_id}"
      end
      
      # Curious that this one requires the 4a parameter to work for some reason
      da.info_url = "#{base_url}?page=found&4a=16,12,15,13,14,18,17&7=#{application_number}&8=#{application_year}"
      # Deciding to point the comment link to the same page as the info link here because I'm not
      # sure I can reliably generate the email like they want it on the info page
      da.comment_url = da.info_url
      da
    end
  end
end