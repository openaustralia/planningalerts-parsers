require 'rubygems'
require 'mechanize'

class Scraper
  attr_reader :agent

  def initialize
    @agent = WWW::Mechanize.new    
  end
  
  # A version of the short name that is encoded for use in url's
  def planning_authority_short_name_encoded
    planning_authority_short_name.downcase.gsub(' ', '_')
  end
end

