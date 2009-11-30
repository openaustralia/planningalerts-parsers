#!/usr/bin/env ruby
#
# This is a Sinatra web application. To use in a development mode start by doing "shotgun scraper_server.rb"

require 'rubygems'
require 'sinatra'
require 'scraper_factory'

# Return a list of all the scrapers found here
get '/' do
  content_type 'application/xml', :charset => 'utf-8'
  
  xml = Builder::XmlMarkup.new(:indent => 2)
  xml.scrapers do
    Scrapers::scrapers.each do |scraper|
      xml.scraper do
        xml.authority_name scraper.class.planning_authority_name
        xml.authority_short_name scraper.class.planning_authority_short_name
        xml.url "#{request.scheme}://#{request.host}:#{request.port}/#{scraper.class.planning_authority_short_name_encoded}?year={year}&month={month}&day={day}"
      end
    end
  end
end

get '/:short_name' do
  content_type 'application/xml', :charset => 'utf-8'
  date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
  Scrapers::scraper_factory(params[:short_name]).applications(date).to_xml
end
