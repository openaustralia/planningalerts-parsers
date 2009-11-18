#!/usr/bin/env ruby
#
# This is a Sinatra web application. To use in a development mode start by doing "shotgun parser_server.rb"

require 'rubygems'
require 'sinatra'

require 'parse_blue_mountains'
require 'parse_brisbane'

get '/blue_mountains' do
  content_type 'application/xml', :charset => 'utf-8'
  date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
  BlueMountainsParser.new.applications(date).to_xml
end

get '/brisbane' do
  content_type 'application/xml', :charset => 'utf-8'
  date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
  BrisbaneParser.new.applications(date).to_xml
end