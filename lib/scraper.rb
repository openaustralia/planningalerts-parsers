require 'rubygems'
require 'mechanize'

class Scraper
  attr_reader :agent

  # TODO: Extract this into Scraper
  class << self
    attr_reader :planning_authority_name, :planning_authority_short_name
  end
  
  def initialize
    @agent = WWW::Mechanize.new    
  end  
end

