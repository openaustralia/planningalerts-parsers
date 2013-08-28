#!/usr/bin/env ruby
#
# This is a Sinatra web application with dependencies managed by Bundler
# To use in a development mode simply run `shotgun` (which reads `config.ru`)
require './scraper_factory'

class ScraperServer < Sinatra::Base
  set :raise_errors, true

  use ExceptionNotification::Rack,
    :email => {
      :sender_address => 'contact@planningalerts.org.au',
      :exception_recipients => %w{web-administrators@openaustralia.org},
      :smtp_settings => { :email_prefix => "[planningalerts-parsers exception] ",
                          :address => "localhost",
                          :openssl_verify_mode => OpenSSL::SSL::VERIFY_NONE,
                          :port => (settings.environment == :production ? 25 : 1025) }
    }

  # Return a list of all the scrapers found here
  get '/' do
    content_type 'application/xml', :charset => 'utf-8'

    xml = Builder::XmlMarkup.new(:indent => 2)
    xml.scrapers do
      Scrapers::scrapers.each do |scraper|
        xml.scraper do
          xml.authority_name scraper.planning_authority_name_no_state
          xml.authority_short_name scraper.planning_authority_short_name
          xml.state scraper.state
          xml.url "#{request.url}#{scraper.planning_authority_short_name_encoded}?year={year}&month={month}&day={day}"
        end
      end
    end
  end

  get '/:short_name' do
    content_type 'application/xml', :charset => 'utf-8'
    if Date.valid_civil?(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      Scrapers::scraper_factory(params[:short_name]).results_as_xml(date)
    end
  end
end
