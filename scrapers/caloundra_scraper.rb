require 'info_master_scraper'

class CaloundraScraper < InfoMasterScraper
  # TODO: This one can definitely return more than a single page of results. We need to be able to handle this.
  def applications(date)
    base_url = "http://pdonline.caloundra.qld.gov.au/modules/applicationmaster/default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 1, 'table#_ctl4_dbGrid').map do |values|
      da = DevelopmentApplication.new(
        :application_id => extract_application_id(values[1]),
        :date_received => extract_date_received(values[2]),
        :address => split_lines(values[3]).first.split("\n\n").first + ", " + state,
        :description => extract_description(values[3])
      )  
      if da.application_id =~ /^(\d+)\/(.+)/
        application_year, application_number = $~[1..2]
      else
        raise "Unexpected form for application_id: #{da.application_id}"
      end
      
      da.info_url = "#{base_url}?page=found&7=#{application_number}&8=#{application_year}"
      # Deciding to point the comment link to the same page as the info link here because I'm not
      # sure I can reliably generate the email like they want it on the info page
      da.comment_url = da.info_url
      da
    end
  end
end