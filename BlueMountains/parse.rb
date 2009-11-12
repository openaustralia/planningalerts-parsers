#!/usr/bin/env ruby
#
# Beginnings of prototype parser for downloading development application information from Blue Mountains Council website

# This is the page that we're parsing
url = "http://www.bmcc.nsw.gov.au/files/daily_planning_notifications.htm"

require 'rubygems'
require 'mechanize'

agent = WWW::Mechanize.new

page = agent.get(url)

page.search('table > tr').each do |row|
  values = row.search('td').map {|t| t.inner_text.strip.delete("\n")}
  unless values.empty?
    application_id = values[0]
    location = values[1]
    description = values[2]
    from = values[3]
    to = values[4]
    puts "application_id: #{application_id}, location: #{location}, description: #{description}, from: #{from}, to: #{to}"
  end
end

