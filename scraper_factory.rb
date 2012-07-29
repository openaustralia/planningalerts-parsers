$:.unshift "#{File.dirname(__FILE__)}/lib"

Dir.glob("#{File.dirname(__FILE__)}/scrapers/*_scraper.rb").each do |file|
  require file
end

# Require the generic scrapers.
# TODO: Should really move these together with all the other scrapers
require 'spear_scraper'
require 'cgi_scraper'
require 'scraperwiki_scraper'

module Scrapers
  # Central registry of scrapers

  # Council provided XML feeds, listed here for completeness:
  # City of Salisbury: http://www.salisbury.sa.gov.au/feed.rss?listID=53
  # Sutherland Shire Council: http://feeds.ssc.nsw.gov.au/?page=PlanningAlerts&Day=1&Month=11&Year=2011

  def self.scrapers
    [BrisbaneScraper.new("Brisbane City Council", "Brisbane", "QLD"),
      BurnsideScraper.new("City of Burnside", "Burnside", "SA"),
      ScraperWikiScraper.new("Gold Coast City Council", "Gold Coast", "QLD", "gold_coast_city_council_development_applications"),
      # TODO: Figure out which of these authorities using the SPEAR system have planning information
      # in the system and which just have subdivision information
      SPEARScraper.new("Ararat Rural City Council (SPEAR)", "Ararat", "VIC", "Ararat Rural City Council"),
      SPEARScraper.new("Ballarat City Council (SPEAR)", "Ballarat", "VIC", "Ballarat City Council"),
      SPEARScraper.new("Banyule City Council (SPEAR)", "Banyule", "VIC", "Banyule City Council"),
      # There are two websites that we're getting data for Boroondara City Council from.
      # Using "Boroondara (City)" to disambiguate from the "Boroondara" used by the SPEAR scraper.
      SPEARScraper.new("Boroondara City Council (SPEAR)", "Boroondara", "VIC", "Boroondara City Council"),
      BoroondaraScraper.new("Boroondara City Council", "Boroondara (City)", "VIC"),
      SPEARScraper.new("Brimbank City Council (SPEAR)", "Brimbank", "VIC", "Brimbank City Council"),
      SPEARScraper.new("Cardinia Shire Council (SPEAR)", "Cardinia", "VIC", "Cardinia Shire Council"),
      SPEARScraper.new("Casey City Council (SPEAR)", "Casey", "VIC", "Casey City Council"),
      SPEARScraper.new("Central Goldfields Shire Council (SPEAR)", "Central Goldfields", "VIC", "Central Goldfields Shire Council"),
      SPEARScraper.new("City of Greater Dandenong (SPEAR)", "Dandenong", "VIC", "City of Greater Dandenong"),
      SPEARScraper.new("City of Greater Geelong (SPEAR)", "Geelong", "VIC", "City of Greater Geelong"),
      SPEARScraper.new("Darebin City Council (SPEAR)", "Darebin", "VIC", "Darebin City Council"),
      SPEARScraper.new("Frankston City Council (SPEAR)", "Frankston", "VIC", "Frankston City Council"),
      SPEARScraper.new("Gannawarra Shire Council (SPEAR)", "Gannawarra", "VIC", "Gannawarra Shire Council"),
      SPEARScraper.new("Glenelg Shire Council (SPEAR)", "Glenelg", "VIC", "Glenelg Shire Council"),
      SPEARScraper.new("Golden Plains Shire Council (SPEAR)", "Golden Plains", "VIC", "Golden Plains Shire Council"),
      SPEARScraper.new("Greater Shepparton City Council (SPEAR)", "Shepparton", "VIC", "Greater Shepparton City Council"),
      SPEARScraper.new("Hepburn Shire Council (SPEAR)", "Hepburn", "VIC", "Hepburn Shire Council"),
      SPEARScraper.new("Hobsons Bay City Council (SPEAR)", "Hobsons Bay", "VIC", "Hobsons Bay City Council"),
      SPEARScraper.new("Manningham City Council (SPEAR)", "Manningham", "VIC", "Manningham City Council"),
      SPEARScraper.new("Maroondah City Council (SPEAR)", "Maroondah", "VIC", "Maroondah City Council"),
      # This one is a little strange. Need to see what we can sensibly call it
      SPEARScraper.new("Minister for Planning - Others (SPEAR)", "Victoria", "VIC", "Minister for Planning - Others"),
      SPEARScraper.new("Minister for Planning - Social Housing (SPEAR)", "Victoria (Social Housing)", "VIC", "Minister for Planning - Social Housing"),
      SPEARScraper.new("Mitchell Shire Council (SPEAR)", "Mitchell", "VIC", "Mitchell Shire Council"),
      SPEARScraper.new("Moonee Valley City Council (SPEAR)", "Moonee Valley", "VIC", "Moonee Valley City Council"),
      SPEARScraper.new("Moreland City Council (SPEAR)", "Moreland", "VIC", "Moreland City Council"),
      SPEARScraper.new("Moyne Shire Council (SPEAR)", "Moyne", "VIC", "Moyne Shire Council"),
      SPEARScraper.new("Port Phillip City Council (SPEAR)", "Port Phillip", "VIC", "Port Phillip City Council"),
      SPEARScraper.new("Pyrenees Shire Council (SPEAR)", "Pyrenees", "VIC", "Pyrenees Shire Council"),
      SPEARScraper.new("Shire of Melton (SPEAR)", "Melton", "VIC", "Shire of Melton"),
      SPEARScraper.new("Southern Grampians Shire Council (SPEAR)", "Southern Grampians", "VIC", "Southern Grampians Shire Council"),
      SPEARScraper.new("Surf Coast Shire Council (SPEAR)", "Surf Coast", "VIC", "Surf Coast Shire Council"),
      SPEARScraper.new("Warrnambool City Council (SPEAR)", "Warrnambool", "VIC", "Warrnambool City Council"),
      SPEARScraper.new("Wellington Shire Council (SPEAR)", "Wellington", "VIC", "Wellington Shire Council"),
      SPEARScraper.new("Whittlesea City Council (SPEAR)", "Whittlesea", "VIC", "Whittlesea City Council"),
      SPEARScraper.new("Wyndham City Council (SPEAR)", "Wyndham", "VIC", "Wyndham City Council"),
      SPEARScraper.new("Yarra City Council (SPEAR)", "Yarra", "VIC", "Yarra City Council"),
      SPEARScraper.new("Alpine Shire Council (SPEAR)", "Alpine", "VIC", "Alpine Shire Council"),
      SPEARScraper.new("Bayside City Council (SPEAR)", "Bayside", "VIC", "Bayside City Council"),
      SPEARScraper.new("Benalla Rural City Council (SPEAR)", "Benalla", "VIC", "Benalla Rural City Council"),
      SPEARScraper.new("Greater Bendigo City Council (SPEAR)", "Bendigo", "VIC", "Greater Bendigo City Council"),
      SPEARScraper.new("Hume City Council (SPEAR)", "Hume", "VIC", "Hume City Council"),
      SPEARScraper.new("Maribyrnong City Council (SPEAR)", "Maribyrnong", "VIC", "Maribyrnong City Council"),
      SPEARScraper.new("Rural City of Wangaratta (SPEAR)", "Wangaratta", "VIC", "Rural City of Wangaratta"),
      SPEARScraper.new("Shire of Campaspe (SPEAR)", "Campaspe", "VIC", "Shire of Campaspe"),
      SPEARScraper.new("Stonnington City Council (SPEAR)", "Stonnington (SPEAR)", "VIC", "Stonnington City Council"),
      ScraperWikiScraper.new("Moreton Bay Regional Council", "Moreton Bay", "QLD", "moreton_bay_regional_council_development_applicati"),
      CaloundraScraper.new("Caloundra, Sunshine Coast Regional Council", "Caloundra", "QLD"),
      MaroochyScraper.new("Maroochydore and Nambour offices, Sunshine Coast Regional Council", "Maroochy", "QLD"),
      NoosaScraper.new("Noosa, Sunshine Coast Regional Council", "Noosa", "QLD"),
      BlacktownScraper.new("Blacktown City Council", "Blacktown", "NSW"),
      SydneyScraper.new("City of Sydney", "Sydney", "NSW"),
      LoganScraper.new("Logan City Council", "Logan", "QLD"),
      WoollahraScraper.new("Woollahra Municipal Council", "Woollahra", "NSW"),
      ScraperWikiScraper.new("Randwick City Council", "Randwick", "NSW", "randwick_city_council_development_applications"),
      ACTScraper.new("ACT Planning & Land Authority", "ACT", "ACT"),
      MosmanScraper.new("Mosman Municipal Council", "Mosman", "NSW"),
      # There are two websites that we're getting data for Melbourne City Council from.
      # Using "Melbourne (City)" to disambiguate from the "Melbourne" used by the SPEAR scraper.
      SPEARScraper.new("Melbourne City Council (SPEAR)", "Melbourne", "VIC", "Melbourne City Council"),
      MelbourneScraper.new("Melbourne City Council", "Melbourne (City)", "VIC"),
      WollongongScraper.new("Wollongong City Council", "Wollongong", "NSW"),
      ScraperWikiScraper.new("Marrickville Council", "Marrickville", "NSW", "marrickville-council-development-applications"),
      CGIScraper.new("Department of Planning and Local Government", "EDALA", "SA", "php-cgi -d short_open_tag=0 -d cgi.force_redirect=0 -f", "edala.php"),
      KogarahScraper.new("Kogarah City Council", "Kogarah", "NSW"),
      LakeMacquarieScraper.new("Lake Macquarie City Council", "Lake Macquarie", "NSW"),
      ScraperWikiScraper.new("Parramatta City Council", "Parramatta", "NSW", "parramatta-city-council-development-applications"),
      KuringgaiScraper.new("Ku-ring-gai Council", "Ku-ring-gai", "NSW"),
      AlburyScraper.new("Albury City Council", "Albury", "NSW"),
      ScraperWikiScraper.new("City of Stonnington", "Stonnington", "VIC", "city_of_stonnington_development_applications"),
      WarringahScraper.new("Warringah Council", "Warringah", "NSW"),
      YarraScraper.new("City of Yarra", "Yarra City", "VIC"),
      ScraperWikiScraper.new("Leichhardt Municipal Council", "Leichhardt", "NSW", "leichhardt_municipal_council_development_applicati"),
      WaggaWaggaScraper.new("City of Wagga Wagga", "Wagga Wagga", "NSW"),
      GriffithScraper.new("Griffith City Council", "Griffith", "NSW"),
      ScraperWikiScraper.new("Penrith City Council", "Penrith", "NSW", 'penrith_city_council_development_applications'),
      ScraperWikiScraper.new("Pittwater Council", "Pittwater", "NSW", "pittwater_council_development_applications"),
      WyongScraper.new("Wyong Shire Council", "Wyong", "NSW"),
      ScraperWikiScraper.new("North Sydney Council", "North Sydney", "NSW", "north_sydney_council_development_applications"),
      HawkesburyScraper.new("Hawkesbury City Council", "Hawkesbury", "NSW"),
      HornsbyScraper.new("Hornsby Shire Council", "Hornsby", "NSW"),
      FraserCoastScraper.new("Fraser Coast Regional Council", "Fraser Coast", "QLD"),
      IpswichScraper.new("City of Ipswich", "Ipswich", "QLD"),
      LockyerValleyScraper.new("Lockyer Valley Regional Council", "Lockyer Valley", "QLD"),
      ToowoombaScraper.new("Toowoomba Regional Council", "Toowoomba", "QLD"),
      RedlandScraper.new("Redland City Council", "Redland", "QLD"),
      ScraperWikiScraper.new("City of Marion", "Marion", "SA", "city_of_marion_development_applications"),
      BankstownScraper.new("Bankstown City Council", "Bankstown", "NSW"),
      CoffsHarbourScraper.new("Coffs Harbour City Council", "Coffs Harbour", "NSW"),
      TheHillsScraper.new("The Hills Shire Council", "The Hills", "NSW"),
      ScraperWikiScraper.new("Waverley Council", "Waverley", "NSW", "waverley_council_development_applications"),
      ScraperWikiScraper.new("Blue Mountains City Council", "Blue Mountains", "NSW", "blue-mountains-city-council-development-applicatio"),
      ScraperWikiScraper.new("Bellingen Shire Council", "Bellingen", "NSW", "bellingen-shire-council-development-applications"),
      ScraperWikiScraper.new("NSW Department of Planning Major Project Assessments", "NSW DoP", "NSW", "nsw_department_of_planning_major_project_assessmen"),
      ScraperWikiScraper.new("City of Kingston", "Kingston", "VIC", "city_of_kingston_development_applications"),
      CGIScraper.new("Moreland City Council", "Moreland (City)", "VIC", "perl", "moreland.pl"),
      ScraperWikiScraper.new("NSW Office of Liquor, Gaming and Racing", "NSW OLGR", "NSW", "nsw_office_of_liquor_gaming_and_racing_-_liquor_ap"),
      ScraperWikiScraper.new("City of Ryde", "Ryde", "NSW", "city_of_ryde_development_applications"),
      ScraperWikiScraper.new("Mornington Peninsula Shire", "Mornington Peninsula", "VIC", "mornington_peninsula_shire_-_development_applicati"),
      ScraperWikiScraper.new("Lane Cove Council", "Lane Cove", "NSW", "lane_cove_da_scraper"),
      ScraperWikiScraper.new("Northern Territory Lands Group", "Northern Territory", "NT", "northern_territory_development_applications"),
      ScraperWikiScraper.new("City of Cockburn", "Cockburn", "WA", "city_of_cockburn_development_applications"),
      ScraperWikiScraper.new("Hobart City Council", "Hobart", "TAS", "hobart_city_council_development_applications"),
      ScraperWikiScraper.new("Mackay Regional Council", "Mackay", "QLD", "mackay_city_council_development_applications"),
      ScraperWikiScraper.new("Knox City Council", "Knox", "VIC", "knox_regional_council_development_applications"),
      ScraperWikiScraper.new("Port Stephens Council", "Port Stephens", "NSW", "port_stephens_development_applications"),
      ScraperWikiScraper.new("Clarence City Council", "Clarence", "TAS", "clarence_city_council_development_applications"),
      ScraperWikiScraper.new("Shoalhaven City Council", "Shoalhaven", "NSW", "shoalhaven_council_development_applications"),
      ScraperWikiScraper.new("Rockdale City Council", "Rockdale", "NSW", "rockdale_applications"),
      ScraperWikiScraper.new("Ballina Shire Council", "Ballina", "NSW", "ballina_shire_council_development_applications"),
      ScraperWikiScraper.new("Campbelltown City Council", "Campbelltown", "NSW", "campbelltown_city_council_development_proposals"),
      ScraperWikiScraper.new("City of Vincent", "Vincent", "WA", "city_of_vincent_wa_development_applications"),
      ScraperWikiScraper.new("Gosford City Council", "Gosford", "NSW", "gosford_nsw_development_applications"),
      ScraperWikiScraper.new("City of Onkaparinga", "Onkaparinga", "SA", "onkaparinga_sa_development_applications"),
      ScraperWikiScraper.new("Fairfield City Council", "Fairfield", "NSW", "fairfield_city_development_applications"),
      ScraperWikiScraper.new("Scenic Rim Regional Council", "Scenic Rim", "QLD", "scenic_rim_regional_council_development_applicatio"),
      ScraperWikiScraper.new("Townsville City Council", "Townsville", "QLD", "townsville_city_council_development_applications"),
      ScraperWikiScraper.new("Singleton Council", "Singleton", "NSW", "singleton_council_development_applications"),
      ScraperWikiScraper.new("Bundaberg Regional Council", "Bundaberg", "QLD", "bundaberg_regional_council_development_application"),
      ScraperWikiScraper.new("Willoughby City Council", "Willoughby", "NSW", "willoughby_da_scraper_1"),
      ScraperWikiScraper.new("Muswellbrook Shire Council", "Muswellbrook", "NSW", "muswellbrook_shire_council_development_application"),
      ScraperWikiScraper.new("City of Ballarat", "Ballarat (City)", "VIC", "city_of_ballarat_development_applications"),
      ScraperWikiScraper.new("City of Greater Geelong", "Geelong (City)", "VIC", "city_of_greater_geelong_development_applications"),
      ScraperWikiScraper.new("Nillumbik Shire Council", "Nillumbik", "VIC", "nillumbik_shire_council_development_applications"),
      ScraperWikiScraper.new("Surf Coast Shire Council", "Surf Coast Shire", "VIC", "surf_coast_shire_council_development_applications"),
      ScraperWikiScraper.new("Victorian Commission for Gambling and Liquor Regulation", "VCGLR", "VIC", "victorian_liquor_licence_applications_1"),
    ]
  end
  
  def self.scraper_factory(name)
    scrapers.find{|p| p.planning_authority_short_name_encoded == name}
  end
end
