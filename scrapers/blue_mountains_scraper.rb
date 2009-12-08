$:.unshift "#{File.dirname(__FILE__)}/../lib"

require 'scraper'

class BlueMountainsScraper < Scraper
  def planning_authority_name; "Blue Mountains City Council, NSW"; end
  def planning_authority_short_name; "Blue Mountains"; end
  
  def applications(date)
    # TODO: We're currently ignoring the date. Need to figure out what to do here
    
    # This is the page that we're parsing
    url = "http://www.bmcc.nsw.gov.au/files/daily_planning_notifications.htm"
    info_url = "http://www.bmcc.nsw.gov.au/sustainableliving/developmentapplicationsinnotification/"
    
    agent.get(url).search('table > tr').map do |row|
      values = row.search('td').map {|t| t.inner_text.strip.delete("\n")}
      DevelopmentApplication.new(:application_id => values[0], :address => values[1], :description => values[2],
        :on_notice_from => values[3], :on_notice_to => values[4], :info_url => info_url, :comment_url => info_url) unless values.empty?
    end
  end
end

