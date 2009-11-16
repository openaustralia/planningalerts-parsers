#!/usr/bin/env ruby
#
# Beginnings of prototype parser for downloading development application information from Blue Mountains Council website

require 'rubygems'
require 'mechanize'

require 'planning_authority_results'

# This is the page that we're parsing
url = "http://www.bmcc.nsw.gov.au/files/daily_planning_notifications.htm"
planning_authority_name = "Blue Mountains City Council"
planning_authority_short_name = "Blue Mountains"

agent = WWW::Mechanize.new
page = agent.get(url)
results = PlanningAuthorityResults.new(:name => planning_authority_name, :short_name => planning_authority_short_name)
page.search('table > tr').each do |row|
  values = row.search('td').map {|t| t.inner_text.strip.delete("\n")}
  results << DevelopmentApplication.new(:application_id => values[0], :address => values[1], :description => values[2],
    :on_notice_from => values[3], :on_notice_to => values[4]) unless values.empty?
end
puts results.to_xml