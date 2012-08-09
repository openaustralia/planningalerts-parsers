# Configuration file for starting this application using Passenger
# Not needed for normal development, just for deployment

require 'rubygems'
require 'bundler'

Bundler.require

require './scraper_server'

# Send out email on any exceptions raised
use Rack::MailExceptions do |mail|
  mail.from "contact@planningalerts.org.au"
  mail.to "web-administrators@openaustralia.org"
end

# This will allow exceptions to go outside of Sinatra to be caught by the MailExceptions handler
set :raise_errors, true

run Sinatra::Application
