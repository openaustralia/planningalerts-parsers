require 'bundler'

Bundler.require(:default, :test)

require "#{File.dirname(__FILE__)}/../scraper_server.rb"

VCR.configure do |c|
  c.cassette_library_dir = "#{File.dirname(__FILE__)}/fixtures/vcr_cassettes"
  c.hook_into :webmock
end
