#!/usr/bin/env ruby
#
# Using a Google Search for "Powered by Infomaster" try to locate all the councils that use the
# Infomaster system for Development applications. Try to match the domains up with the council names
#
# Using the Google AJAX Search API. Documentation for this is at http://code.google.com/apis/ajaxsearch/documentation/
#

require 'rubygems'
require 'mechanize'
require 'json'
require 'logger'

agent = WWW::Mechanize.new
#logger = Logger.new $stdout 
#agent.log = logger

# Setting the referrer page (as we are required to do by the Google terms of service)
referrer = WWW::Mechanize::Page.new(URI.parse('http://www.openaustralia.org'),{ 'content-type' => 'text/html' })

unique_hosts = {}

# Get 20 results
start = 0
while (start < 20)
  puts "Collecting search results starting at: #{start}"
  page = agent.get("http://ajax.googleapis.com/ajax/services/search/web?v=1.0&rsz=large&q=%22Powered+by+Infomaster%22&start=#{start}",
    referrer)

  result = JSON.parse(page.body)
  result['responseData']['results'].each do |r|
    uri = URI.parse(r['url'])
    if unique_hosts.has_key?(uri.host)
      #puts "Already found this host: #{uri.host}"
      # Append the url to the list
      unique_hosts[uri.host] << uri
    else
      #puts "NEW host: #{uri.host} with URL: #{uri}"
      unique_hosts[uri.host] = [uri]
    end
  end
  start += result['responseData']['results'].size
end

# Now display the results. For easy reading split into .gov.au, numeric IP addresses and others

hosts = unique_hosts.keys
wa_gov_hosts = hosts.find_all {|h| h =~ /\.wa\.gov\.au$/}
hosts -= wa_gov_hosts
nsw_gov_hosts = hosts.find_all {|h| h =~ /\.nsw\.gov\.au$/}
hosts -= nsw_gov_hosts
qld_gov_hosts = hosts.find_all {|h| h =~ /\.qld\.gov\.au$/}
hosts -= qld_gov_hosts
other_gov_hosts = hosts.find_all {|h| h =~ /\.gov\.au$/}
hosts -= other_gov_hosts
numeric_hosts = hosts.find_all {|h| h =~ /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/}
hosts -= numeric_hosts

puts "\nWA Government sites:\n#{wa_gov_hosts.join("\n")}"
puts "\nNSW Government sites:\n#{nsw_gov_hosts.join("\n")}"
puts "\nQLD Government sites:\n#{qld_gov_hosts.join("\n")}"
puts "\nOther Government sites:\n#{other_gov_hosts.join("\n")}" unless other_gov_hosts.empty?
puts "\nSites with IP addresses:\n#{numeric_hosts.join("\n")}"
puts "\nOther sites:\n#{hosts.join("\n")}" unless hosts.empty?

