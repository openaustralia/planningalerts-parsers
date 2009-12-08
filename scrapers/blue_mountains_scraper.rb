$:.unshift "#{File.dirname(__FILE__)}/../lib"

require 'scraper'

class BlueMountainsScraper < Scraper
  attr_reader :agent, :planning_authority_name, :planning_authority_short_name

  def initialize(name, short_name)
    super()
    @planning_authority_name, @planning_authority_short_name = name, short_name
  end

  def applications(date)
    # TODO: We're currently ignoring the date. Need to figure out what to do here
    
    # This is the page that we're parsing
    url = "http://www.bmcc.nsw.gov.au/files/daily_planning_notifications.htm"
    info_url = "http://www.bmcc.nsw.gov.au/sustainableliving/developmentapplicationsinnotification/"
    
    agent.get(url).search('table > tr')[1..-1].map do |row|
      values = row.search('td').map {|t| t.inner_text.strip.delete("\n")}
      DevelopmentApplication.new(:application_id => values[0], :address => values[1], :description => values[2],
        :on_notice_from => values[3], :on_notice_to => values[4], :info_url => info_url, :comment_url => info_url)
    end
  end
end

