#!/usr/bin/env ruby
#
# This is a Sinatra web application. To use in a development mode start by doing "shotgun parser_server.rb"

require 'rubygems'
require 'sinatra'

require 'parse_blue_mountains'
require 'parse_brisbane'

get '/blue_mountains' do
  content_type 'application/xml', :charset => 'utf-8'
  BlueMountainsParser.new.applications.to_xml
end

get '/brisbane' do
  content_type 'application/xml', :charset => 'utf-8'
  BrisbaneParser.new.applications(Date.new(2009,11,12)).to_xml
end