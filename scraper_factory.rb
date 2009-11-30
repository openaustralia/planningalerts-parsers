$:.unshift "#{File.dirname(__FILE__)}/scrapers"

require 'blue_mountains_scraper'
require 'brisbane_scraper'
require 'gold_coast_scraper'
require 'spear_scraper'

module Scrapers
  # Central registry of scrapers
  def self.scrapers
    [BlueMountainsScraper.new,
      BrisbaneScraper.new,
      GoldCoastScraper.new,
      SPEARScraper.new("Casey City Council", "Casey", "Casey City Council")]
  end
  
  def self.scraper_factory(name)
    scrapers.find{|p| p.planning_authority_short_name_encoded == name}
  end
end

