# Configuration file for starting this application using Passenger
# Not needed for normal development, just for deployment

require 'rubygems'
require 'sinatra'
require 'scraper_server'
require 'rack'
require 'rack/contrib'

# Send out email on any exceptions raised
use Rack::MailExceptions do |mail|
  mail.from "contact@planningalerts.org.au"
  mail.to "matthew@openaustralia.org"
end

# When running from this rackup script we'll always be in production mode
# Putting it in production mode will not display exceptions which will then trickle up to
# exceptions mailer so we should then get an email
set :environment, :production

run Sinatra::Application