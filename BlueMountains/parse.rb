#!/usr/bin/env ruby
#
# Beginnings of prototype parser for downloading development application information from Blue Mountains Council website

$:.unshift "#{File.dirname(__FILE__)}/../"

require 'rubygems'
require 'mechanize'

require 'planning_authority_results'

# This is the page that we're parsing
url = "http://www.bmcc.nsw.gov.au/files/daily_planning_notifications.htm"

agent = WWW::Mechanize.new

page = agent.get(url)

results = PlanningAuthorityResults.new

page.search('table > tr').each do |row|
  values = row.search('td').map {|t| t.inner_text.strip.delete("\n")}
  results << DevelopmentApplication.new(:application_id => values[0], :address => values[1], :description => values[2],
    :on_notice_from => values[3], :on_notice_to => values[4]) unless values.empty?
end

results.applications.each do |da|
  puts "application_id: #{da.application_id}, location: #{da.address}, description: #{da.description}, from: #{da.on_notice_from}, to: #{da.on_notice_to}"  
end
