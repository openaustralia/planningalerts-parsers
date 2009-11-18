#!/usr/bin/env ruby
#
# This is a Sinatra web application. To use in a development mode start by doing "shotgun parser_server.rb"

require 'rubygems'
require 'sinatra'

require 'parse_blue_mountains'
require 'parse_brisbane'

helpers do
  def parser_factory(name)
    parsers = [BlueMountainsParser.new, BrisbaneParser.new]
    parsers.find{|p| p.planning_authority_short_name.downcase.gsub(' ', '_') == name}
  end
end

get '/:short_name' do
  content_type 'application/xml', :charset => 'utf-8'
  date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
  parser_factory(params[:short_name]).applications(date).to_xml
end
