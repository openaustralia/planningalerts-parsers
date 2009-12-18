require 'rubygems'
require 'mechanize'
require 'planning_authority_results'
require 'uri'

class Scraper
  attr_reader :agent, :planning_authority_short_name, :state

  def initialize(name, short_name, state)
    @planning_authority_name, @planning_authority_short_name, @state = name, short_name, state
    @agent = WWW::Mechanize.new    
  end
  
  # Append the state/territory onto the planning authority name
  def planning_authority_name
    @planning_authority_name + ", " + state
  end
  
  def extract_relative_url(html)
    agent.page.uri + URI.parse(html.at('a').attributes['href'])
  end
  
  def email_url(to, subject, body = nil)
    v = "mailto:#{to}?subject=#{URI.escape(subject)}"
    v += "&Body=#{URI.escape(body)}" if body
    v
  end
  
  # A version of the short name that is encoded for use in url's
  def planning_authority_short_name_encoded
    planning_authority_short_name.downcase.gsub(' ', '_').gsub(/\W/, '')
  end
  
  def results(date)
    PlanningAuthorityResults.new(:name => planning_authority_name, :short_name => planning_authority_short_name,
      :applications => applications(date))
  end
end

