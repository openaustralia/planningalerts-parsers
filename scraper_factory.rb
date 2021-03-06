$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'scraper'

Dir.glob("#{File.dirname(__FILE__)}/scrapers/*_scraper.rb").each do |file|
  require file
end

# Require the generic scrapers.
# TODO: Should really move these together with all the other scrapers
require 'cgi_scraper'

module Scrapers
  # Central registry of scrapers
  # Note that this is not an exhaustive list as some councils provide XML feeds
  # and ScraperWiki hosts many scrapers
  def self.scrapers
    [
      RedlandScraper.new("Redland City Council", "Redland", "QLD")
    ]
  end

  def self.scraper_factory(name)
    scrapers.find{|p| p.planning_authority_short_name_encoded == name}
  end
end
