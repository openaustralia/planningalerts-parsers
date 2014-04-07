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
      BrisbaneScraper.new("Brisbane City Council", "Brisbane", "QLD"),
      FraserCoastScraper.new("Fraser Coast Regional Council", "Fraser Coast", "QLD"),
      GriffithScraper.new("Griffith City Council", "Griffith", "NSW"),
      HornsbyScraper.new("Hornsby Shire Council", "Hornsby", "NSW"),
      IpswichScraper.new("City of Ipswich", "Ipswich", "QLD"),
      KuringgaiScraper.new("Ku-ring-gai Council", "Ku-ring-gai", "NSW"),
      LoganScraper.new("Logan City Council", "Logan", "QLD"),
      RedlandScraper.new("Redland City Council", "Redland", "QLD"),
      WarringahScraper.new("Warringah Council", "Warringah", "NSW"),
      WollongongScraper.new("Wollongong City Council", "Wollongong", "NSW"),
      WyongScraper.new("Wyong Shire Council", "Wyong", "NSW")
    ]
  end
  
  def self.scraper_factory(name)
    scrapers.find{|p| p.planning_authority_short_name_encoded == name}
  end
end
