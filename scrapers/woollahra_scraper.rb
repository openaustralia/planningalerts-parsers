require 'scraper'

class WoollahraScraper < Scraper
  def applications(date)
    # Doesn't seem to work without that nodeNum. I wonder what it is.
    url = "https://ecouncil.woollahra.nsw.gov.au/eservice/advertisedDAs.do?&orderBy=suburb&nodeNum=5265"
    # We can't give a link directly to an application. Bummer. So, giving link to the search page
    info_url = "https://ecouncil.woollahra.nsw.gov.au/eservice/daEnquiryInit.do?nodeNum=5270"
    comment_url = "http://www.woollahra.nsw.gov.au/building_and_development/objections_and_comments/object_or_comment_on_a_da"
    page = agent.get(url)
    
    # The applications are grouped by suburb. So, stepping through so we can track the current suburb
    current_suburb = nil
    applications = []
    page.at('#fullcontent .bodypanel').children.each do |block|
      case block.name
      when "text", "comment", "script"
        # Do nothing
      when "h4"
        current_suburb = block.inner_text.strip
      when "table"
        address = block.search('tr')[0].inner_text.strip + ", " + current_suburb + ", " + state
        description = block.search('tr')[1].search('td')[2].inner_text.strip
        application_id = block.search('tr')[3].search('td')[2].inner_text.strip
        on_notice_text = block.search('tr')[4].search('td')[2].inner_text.strip
        if on_notice_text =~ /(\d+\/\d+\/\d+)\s+Expires\s+(\d+\/\d+\/\d+)/
          on_notice_from, on_notice_to = $~[1..2]
        else
          raise "Unexpected form for text: #{on_notice_text}"
        end
        applications << DevelopmentApplication.new(
          :address => address,
          :description => description,
          :application_id => application_id,
          :on_notice_from => on_notice_from,
          :on_notice_to => on_notice_to,
          :info_url => info_url,
          :comment_url => comment_url)
      else
        raise "Unexpected type: #{block.name}"
      end
    end
    applications
  end
end