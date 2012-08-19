require 'planning_authority_results'
require 'development_application'

# Base class for ruby and non-ruby scrapers
class ScraperBase
  attr_reader :planning_authority_short_name, :state, :scraperwiki_name
  
  def initialize(name, short_name, state)
    @planning_authority_name, @planning_authority_short_name, @state = name, short_name, state
  end
  
  # Append the state/territory onto the planning authority name
  def planning_authority_name
    planning_authority_name_no_state + ", " + state
  end
  
  def planning_authority_name_no_state
    @planning_authority_name
  end
  
  # A version of the short name that is encoded for use in url's
  def planning_authority_short_name_encoded
    planning_authority_short_name.downcase.gsub(' ', '_').gsub(/\W/, '')
  end 
end

class Scraper < ScraperBase
  attr_reader :agent

  def initialize(name, short_name, state)
    super
    @agent = Mechanize.new
  end
  
  def extract_relative_url(html)
    agent.page.uri + URI.parse(html.at('a').attributes['href'])
  end
  
  def email_url(to, subject, body = nil)
    v = "mailto:#{to}?subject=#{URI.escape(subject)}"
    v += "&Body=#{URI.escape(body)}" if body
    v
  end
  
  def simplify_whitespace(str)
    str.gsub(/[\n\t\r]/, " ").squeeze(" ")
  end
  
  def results_as_xml(date)
    results(date).to_xml
  end
  
  def results(date)
    PlanningAuthorityResults.new(:name => planning_authority_name, :short_name => planning_authority_short_name,
      :applications => applications(date))
  end
end

