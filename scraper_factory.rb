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

  # Council provided XML feeds, listed here for completeness:
  # City of Salisbury: http://www.salisbury.sa.gov.au/feed.rss?listID=53
  # Sutherland Shire Council: http://feeds.ssc.nsw.gov.au/?page=PlanningAlerts&Day=1&Month=11&Year=2011
  # Launceston City Council, TAS: http://api.launceston.tas.gov.au/planning/planningAlerts.ashx

  def self.scrapers
    [BrisbaneScraper.new("Brisbane City Council", "Brisbane", "QLD"),
      BoroondaraScraper.new("Boroondara City Council", "Boroondara (City)", "VIC"),
      SydneyScraper.new("City of Sydney", "Sydney", "NSW"),
      LoganScraper.new("Logan City Council", "Logan", "QLD"),
      ACTScraper.new("ACT Planning & Land Authority", "ACT", "ACT"),
      MosmanScraper.new("Mosman Municipal Council", "Mosman", "NSW"),
      WollongongScraper.new("Wollongong City Council", "Wollongong", "NSW"),
      CGIScraper.new("Department of Planning and Local Government", "EDALA", "SA", "php-cgi -d short_open_tag=0 -d cgi.force_redirect=0 -f", "edala.php"),
      KogarahScraper.new("Kogarah City Council", "Kogarah", "NSW"),
      LakeMacquarieScraper.new("Lake Macquarie City Council", "Lake Macquarie", "NSW"),
      KuringgaiScraper.new("Ku-ring-gai Council", "Ku-ring-gai", "NSW"),
      AlburyScraper.new("Albury City Council", "Albury", "NSW"),
      WarringahScraper.new("Warringah Council", "Warringah", "NSW"),
      WaggaWaggaScraper.new("City of Wagga Wagga", "Wagga Wagga", "NSW"),
      GriffithScraper.new("Griffith City Council", "Griffith", "NSW"),
      WyongScraper.new("Wyong Shire Council", "Wyong", "NSW"),
      HawkesburyScraper.new("Hawkesbury City Council", "Hawkesbury", "NSW"),
      HornsbyScraper.new("Hornsby Shire Council", "Hornsby", "NSW"),
      FraserCoastScraper.new("Fraser Coast Regional Council", "Fraser Coast", "QLD"),
      IpswichScraper.new("City of Ipswich", "Ipswich", "QLD"),
      LockyerValleyScraper.new("Lockyer Valley Regional Council", "Lockyer Valley", "QLD"),
      ToowoombaScraper.new("Toowoomba Regional Council", "Toowoomba", "QLD"),
      RedlandScraper.new("Redland City Council", "Redland", "QLD"),
      CoffsHarbourScraper.new("Coffs Harbour City Council", "Coffs Harbour", "NSW"),
      CGIScraper.new("Moreland City Council", "Moreland (City)", "VIC", "perl", "moreland.pl"),
    ]
  end
  
  def self.scraper_factory(name)
    scrapers.find{|p| p.planning_authority_short_name_encoded == name}
  end
end
