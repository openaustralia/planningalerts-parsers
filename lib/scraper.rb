require 'rubygems'
require 'mechanize'
require 'planning_authority_results'
require 'uri'

class Scraper
  attr_reader :agent, :planning_authority_name, :planning_authority_short_name

  def extract_relative_url(html)
    agent.page.uri + URI.parse(html.at('a').attributes['href'])
  end
  
  def email_url(to, subject, body)
    "mailto:#{to}?subject=#{URI.escape(subject)}&Body=#{URI.escape(body)}"
  end
  
  def initialize(name, short_name)
    @planning_authority_name, @planning_authority_short_name = name, short_name
    @agent = WWW::Mechanize.new    
  end
  
  # A version of the short name that is encoded for use in url's
  def planning_authority_short_name_encoded
    planning_authority_short_name.downcase.gsub(' ', '_')
  end
  
  def results(date)
    PlanningAuthorityResults.new(:name => planning_authority_name, :short_name => planning_authority_short_name,
      :applications => applications(date))
  end
end

