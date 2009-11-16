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

p table
