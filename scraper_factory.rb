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
    [BrisbaneScraper.new("Brisbane City Council", "Brisbane", "QLD"),
      BoroondaraScraper.new("Boroondara City Council", "Boroondara (City)", "VIC"),
      LoganScraper.new("Logan City Council", "Logan", "QLD"),
      ACTScraper.new("ACT Planning & Land Authority", "ACT", "ACT"),
      WollongongScraper.new("Wollongong City Council", "Wollongong", "NSW"),
      EdalaScraper.new("Department of Planning and Local Government", "EDALA", "SA"),
      KogarahScraper.new("Kogarah City Council", "Kogarah", "NSW"),
      KuringgaiScraper.new("Ku-ring-gai Council", "Ku-ring-gai", "NSW"),
      AlburyScraper.new("Albury City Council", "Albury", "NSW"),
      WarringahScraper.new("Warringah Council", "Warringah", "NSW"),
      WaggaWaggaScraper.new("City of Wagga Wagga", "Wagga Wagga", "NSW"),
      GriffithScraper.new("Griffith City Council", "Griffith", "NSW"),
      WyongScraper.new("Wyong Shire Council", "Wyong", "NSW"),
      HornsbyScraper.new("Hornsby Shire Council", "Hornsby", "NSW"),
      FraserCoastScraper.new("Fraser Coast Regional Council", "Fraser Coast", "QLD"),
      IpswichScraper.new("City of Ipswich", "Ipswich", "QLD"),
      LockyerValleyScraper.new("Lockyer Valley Regional Council", "Lockyer Valley", "QLD"),
      RedlandScraper.new("Redland City Council", "Redland", "QLD"),
      CGIScraper.new("Moreland City Council", "Moreland (City)", "VIC", "perl", "moreland.pl")
    ]
  end
  
  def self.scraper_factory(name)
    scrapers.find{|p| p.planning_authority_short_name_encoded == name}
  end
end
