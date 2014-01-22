$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'scraper'

Dir.glob("#{File.dirname(__FILE__)}/scrapers/*_scraper.rb").each do |file|
  require file
end

# Require the generic scrapers.
# TODO: Should really move these together with all the other scrapers
require 'cgi_scraper'
require 'scraperwiki_scraper'

module Scrapers
  # Central registry of scrapers
  # Note that this is not an exhaustive list as some councils provide XML feeds
  # and ScraperWiki hosts many scrapers
  def self.scrapers
    [BallinaScraper.new("Ballina Shire Council", "Ballina", "NSW"),
      BrisbaneScraper.new("Brisbane City Council", "Brisbane", "QLD"),
      BoroondaraScraper.new("Boroondara City Council", "Boroondara (City)", "VIC"),
      LoganScraper.new("Logan City Council", "Logan", "QLD"),
      ACTScraper.new("ACT Planning & Land Authority", "ACT", "ACT"),
      WollongongScraper.new("Wollongong City Council", "Wollongong", "NSW"),
      CGIScraper.new("Department of Planning and Local Government", "EDALA", "SA", "php-cgi -d short_open_tag=0 -d cgi.force_redirect=0 -f", "edala.php"),
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
      CGIScraper.new("Moreland City Council", "Moreland (City)", "VIC", "perl", "moreland.pl"),
      ScraperWikiScraper.new("Bankstown City Council", "Bankstown", "NSW"), # Broken (URL & page changed)
      ScraperWikiScraper.new("Bellingen Shire Council", "Bellingen", "NSW"),
      ScraperWikiScraper.new("Blacktown City Council", "Blacktown", "NSW"),
      ScraperWikiScraper.new("Blue Mountains City Council", "Blue Mountains", "NSW"),
      ScraperWikiScraper.new("Bundaberg Regional Council", "Bundaberg", "QLD"),
      ScraperWikiScraper.new("Charters Towers Regional Council", "Charters Towers", "QLD"),
      ScraperWikiScraper.new("City of Ballarat", "Ballarat (City)", "VIC"),
      ScraperWikiScraper.new("City of Burnside", "Burnside", "SA"), # Broken (page changed)
      ScraperWikiScraper.new("City of Cockburn", "Cockburn", "WA"),
      ScraperWikiScraper.new("City of Greater Geelong", "Geelong (City)", "VIC"),
      ScraperWikiScraper.new("City of Kingston", "Kingston", "VIC"),
      ScraperWikiScraper.new("City of Marion", "Marion", "SA"), # Broken
      ScraperWikiScraper.new("Melbourne City Council", "Melbourne (City)", "VIC"),
      ScraperWikiScraper.new("City of Ryde", "Ryde", "NSW"),
      ScraperWikiScraper.new("City of Stonnington", "Stonnington", "VIC"),
      ScraperWikiScraper.new("City of Sydney", "Sydney", "NSW"),
      ScraperWikiScraper.new("City of Unley", "Unley", "SA"),
      ScraperWikiScraper.new("City of Vincent", "Vincent", "WA"),
      ScraperWikiScraper.new("Clarence City Council", "Clarence", "TAS"),
      ScraperWikiScraper.new("Coffs Harbour City Council", "Coffs Harbour", "NSW"), # Broken (by awesome new T&C page)
      ScraperWikiScraper.new("Development Assessment Panels", "DAPs WA", "WA"), # Broken (PDF structure changed?)
      ScraperWikiScraper.new("Gold Coast City Council", "Gold Coast", "QLD"),
      ScraperWikiScraper.new("Gosford City Council", "Gosford", "NSW"), # Broken in production (something to do with SSL)
      ScraperWikiScraper.new("Greater Taree City Council", "Greater Taree", "NSW"),
      ScraperWikiScraper.new("Hawkesbury City Council", "Hawkesbury", "NSW"),
      ScraperWikiScraper.new("Hobart City Council", "Hobart", "TAS"),
      ScraperWikiScraper.new("Knox City Council", "Knox", "VIC"),
      ScraperWikiScraper.new("Lane Cove Council", "Lane Cove", "NSW"),
      ScraperWikiScraper.new("Leichhardt Municipal Council", "Leichhardt", "NSW"),
      ScraperWikiScraper.new("Mackay Regional Council", "Mackay", "QLD"),
      ScraperWikiScraper.new("Marrickville Council", "Marrickville", "NSW"),
      ScraperWikiScraper.new("Moreton Bay Regional Council", "Moreton Bay", "QLD"),
      ScraperWikiScraper.new("Mornington Peninsula Shire", "Mornington Peninsula", "VIC"), # Broken (URL & page changed)
      ScraperWikiScraper.new("Mosman Municipal Council", "Mosman", "NSW"),
      ScraperWikiScraper.new("Muswellbrook Shire Council", "Muswellbrook", "NSW"), # Broken (page has gone missing)
      ScraperWikiScraper.new("Nillumbik Shire Council", "Nillumbik", "VIC"),
      ScraperWikiScraper.new("North Sydney Council", "North Sydney", "NSW"),
      ScraperWikiScraper.new("Northern Territory Lands Group", "Northern Territory", "NT"),
      ScraperWikiScraper.new("NSW Department of Planning Major Project Assessments", "NSW DoP", "NSW"), # Broken (page structure changed)
      ScraperWikiScraper.new("NSW Joint Regional Planning Panels", "NSW JRPP", "NSW"), # Broken (nasty scraper needs a rework)
      ScraperWikiScraper.new("NSW Office of Liquor, Gaming and Racing", "NSW OLGR", "NSW"),
      ScraperWikiScraper.new("City of Onkaparinga", "Onkaparinga", "SA"), # Broken and commented out because it was getting bad data
      ScraperWikiScraper.new("Parramatta City Council", "Parramatta", "NSW"),
      ScraperWikiScraper.new("Penrith City Council", "Penrith", "NSW"),
      ScraperWikiScraper.new("City of Perth", "Perth", "WA"), # Broken (location of PDFs changed)
      ScraperWikiScraper.new("Pittwater Council", "Pittwater", "NSW"),
      ScraperWikiScraper.new("Port Stephens Council", "Port Stephens", "NSW"),
      ScraperWikiScraper.new("Randwick City Council", "Randwick", "NSW"),
      ScraperWikiScraper.new("Rockdale City Council", "Rockdale", "NSW"), # Broken (looks like they've disabled their XML feed)
      ScraperWikiScraper.new("Scenic Rim Regional Council", "Scenic Rim", "QLD"),
      ScraperWikiScraper.new("Yarra Ranges Shire Council", "Yarra Ranges", "VIC"),
      ScraperWikiScraper.new("Shoalhaven City Council", "Shoalhaven", "NSW"),
      ScraperWikiScraper.new("Streamlined Planning through Electronic Applications and Referrals", "SPEAR ,Victoria", "VIC"), # Problematic (gets DAs for lots of councils)
      ScraperWikiScraper.new("Sunshine Coast Regional Council", "Sunshine Coast", "QLD"),
      ScraperWikiScraper.new("Surf Coast Shire Council", "Surf Coast Shire", "VIC"),
      ScraperWikiScraper.new("The Hills Shire Council", "The Hills", "NSW"), # Problematic (takes ages to run)
      ScraperWikiScraper.new("Toowoomba Regional Council", "Toowoomba", "QLD"),
      ScraperWikiScraper.new("Victorian Commission for Gambling and Liquor Regulation", "VCGLR", "VIC"), # Problematic (has to search heaps of pages)
      ScraperWikiScraper.new("Waverley Council", "Waverley", "NSW"),
      ScraperWikiScraper.new("Woollahra Municipal Council", "Woollahra", "NSW"),
      ScraperWikiScraper.new("City of Yarra", "Yarra City", "VIC") # Broken and problematic (has to go through heaps of pages)
    ]
  end
  
  def self.scraper_factory(name)
    scrapers.find{|p| p.planning_authority_short_name_encoded == name}
  end
end
