#!/usr/bin/env ruby
#
# Parser for Brisbane City

$:.unshift "#{File.dirname(__FILE__)}/../"

require 'rubygems'
require 'mechanize'

require 'planning_authority_results'

# This is the page that we're parsing
url = "http://pdonline.brisbane.qld.gov.au/MasterView/modules/applicationmaster/default.aspx?page=search"
planning_authority_name = "Brisbane City Council"
planning_authority_short_name = "Brisbane"

agent = WWW::Mechanize.new
page = agent.get(url)
results = PlanningAuthorityResults.new(:name => planning_authority_name, :short_name => planning_authority_short_name)

# Click the first button on the form
form = page.forms.first
form.submit(form.buttons.first)

# Get the page again
page = agent.get(url)

search_form = page.forms.first
search_form.set_fields( "_ctl2:drDates:txtDay1" => "12", "_ctl2:drDates:txtMonth1" => "11", "_ctl2:drDates:txtYear1" => "2009",
  "_ctl2:drDates:txtDay2" => "12", "_ctl2:drDates:txtMonth2" => "11", "_ctl2:drDates:txtYear2" => "2009")

table = search_form.submit(search_form.button_with(:name => "_ctl2:btnSearch")).search('span#_ctl2_lblData > table')

# TODO: Need to handle what happens when the results span multiple pages. Can this happen?

# Skip first two rows of the table
table.search('tr')[2..-1].each do |row|
  values = row.search('td')
  
  da = DevelopmentApplication.new(
    # The text in the first column is of the form "<application id> - <description>"
    :application_id => values[1].inner_html.split(" - ")[0],
    :description => values[1].inner_html.split(" - ")[1],
    # TODO: Sometimes the address has what I'm assuming is a lot number in brackets after the address. Handle this properly.
    :address => values[2].inner_html.strip,
    :info_url => page.uri + URI.parse(values[0].at('a').attributes['href']))
  da.comment_url = "https://obonline.ourbrisbane.com/services/startDASubmission.do?direct=true&daNumber=#{da.application_id}&sdeprop=#{da.address}"
  results << da
  # The third column has the date that this application was submitted which should always be the date that we've searched for
  # TODO: Double check this
end

# TODO: Include link to where you should respond to the application
puts results.to_xml
