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

# Get 20 results
start = 0
while (start < 20)
  page = agent.get("http://ajax.googleapis.com/ajax/services/search/web?v=1.0&rsz=large&q=%22Powered+by+Infomaster%22&start=#{start}",
    referrer)

  result = JSON.parse(page.body)
  result['responseData']['results'].each do |r|
    p r['url']
  end
  start += result['responseData']['results'].size
end
