require 'info_master_scraper'

class LakeMacquarieScraper < InfoMasterScraper
  def applications(date)
    base_url = "http://apptracking.lakemac.com.au/modules/ApplicationMaster/default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 2, 'span#_ctl4_lblData', 1).map do |values|
      p values
      puts "***"
      description_line = extract_description(values[3], 1..1)
      if description_line =~ /^Description: (.*)/
        description = $~[1]
      else
        raise "Unexpected form for description line"
      end
      da = DevelopmentApplication.new(
        :application_id => extract_application_id(values[1]),
        :description => description,
        :address => extract_address(values[3]),
        :date_received => extract_date_received(values[2]))

      if da.application_id =~ /[A-Z]+-(\d+)\/(\d+)(\/A)?/
        application_number, application_year = $~[1..2]
      else
        raise "Unexpected form for application_id: #{da.application_id}"
      end
      da.info_url = "#{base_url}?page=found&1=01/01/1982&7=#{application_number}&8=#{application_year}"
      da.comment_url = da.info_url
      da
    end
  end
end