require 'rubygems'
require 'mechanize'

class Scraper
  attr_reader :agent

  def initialize
    @agent = WWW::Mechanize.new    
  end  
end

