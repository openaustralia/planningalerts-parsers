require 'rubygems'
require 'mechanize'

class Parser
  attr_reader :agent

  def initialize
    @agent = WWW::Mechanize.new    
  end  
end

