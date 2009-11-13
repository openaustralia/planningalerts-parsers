#!/usr/bin/env ruby
#
# Beginnings of prototype parser for downloading development application information from Blue Mountains Council website

$:.unshift "#{File.dirname(__FILE__)}/../"

require 'rubygems'
require 'mechanize'

require 'development_application'

# This is the page that we're parsing
url = "http://www.bmcc.nsw.gov.au/files/daily_planning_notifications.htm"

agent = WWW::Mechanize.new

page = agent.get(url)

page.search('table > tr').each do |row|
  values = row.search('td').map {|t| t.inner_text.strip.delete("\n")}
  unless values.empty?
    da = DevelopmentApplication.new(:application_id => values[0], :address => values[1], :description => values[2],
      :from => values[3], :to => values[4])
    puts "application_id: #{da.application_id}, location: #{da.address}, description: #{da.description}, from: #{da.from}, to: #{da.to}"
  end
end

