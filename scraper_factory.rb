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
      CGIScraper.new("Department of Planning and Local Government", "EDALA", "SA", "php-cgi -d short_open_tag=0 -d cgi.force_redirect=0 -f", "edala.php"),
      CGIScraper.new("Moreland City Council", "Moreland (City)", "VIC", "perl", "moreland.pl"),
      FraserCoastScraper.new("Fraser Coast Regional Council", "Fraser Coast", "QLD"),
      GriffithScraper.new("Griffith City Council", "Griffith", "NSW"),
      HornsbyScraper.new("Hornsby Shire Council", "Hornsby", "NSW"),
      IpswichScraper.new("City of Ipswich", "Ipswich", "QLD"),
      KogarahScraper.new("Kogarah City Council", "Kogarah", "NSW"),
      KuringgaiScraper.new("Ku-ring-gai Council", "Ku-ring-gai", "NSW"),
      LockyerValleyScraper.new("Lockyer Valley Regional Council", "Lockyer Valley", "QLD"),
      LoganScraper.new("Logan City Council", "Logan", "QLD"),
      RedlandScraper.new("Redland City Council", "Redland", "QLD"),
      WaggaWaggaScraper.new("City of Wagga Wagga", "Wagga Wagga", "NSW"),
      WarringahScraper.new("Warringah Council", "Warringah", "NSW"),
      WollongongScraper.new("Wollongong City Council", "Wollongong", "NSW"),
      WyongScraper.new("Wyong Shire Council", "Wyong", "NSW")
    ]
  end
  
  def self.scraper_factory(name)
    scrapers.find{|p| p.planning_authority_short_name_encoded == name}
  end
end
