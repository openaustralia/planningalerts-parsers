$:.unshift "#{File.dirname(__FILE__)}/scrapers"

require 'blue_mountains_scraper'
require 'brisbane_scraper'
require 'gold_coast_scraper'

def scraper_factory(name)
  scrapers = [BlueMountainsScraper, BrisbaneScraper, GoldCoastScraper]
  scrapers.find{|p| p.planning_authority_short_name.downcase.gsub(' ', '_') == name}.new
end
