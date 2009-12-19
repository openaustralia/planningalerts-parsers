$:.unshift "#{File.dirname(__FILE__)}/lib"

Dir.glob("#{File.dirname(__FILE__)}/scrapers/*_scraper.rb").each do |file|
  require file
end

# Require the generic scrapers.
# TODO: Should really move these together with all the other scrapers
require 'spear_scraper'

module Scrapers
  # Central registry of scrapers
  def self.scrapers
    [BlueMountainsScraper.new("Blue Mountains City Council", "Blue Mountains", "NSW"),
      BrisbaneScraper.new("Brisbane City Council", "Brisbane", "QLD"),
      GoldCoastScraper.new("Gold Coast City Council", "Gold Coast", "QLD"),
      # TODO: Figure out which of these authorities using the SPEAR system have planning information
      # in the system and which just have subdivision information
      SPEARScraper.new("Ararat Rural City Council", "Ararat", "VIC", "Ararat Rural City Council"),
      SPEARScraper.new("Ballarat City Council", "Ballarat", "VIC", "Ballarat City Council"),
      SPEARScraper.new("Banyule City Council", "Banyule", "VIC", "Banyule City Council"),
      SPEARScraper.new("Boroondara City Council", "Boroondara", "VIC", "Boroondara City Council"),
      SPEARScraper.new("Brimbank City Council", "Brimbank", "VIC", "Brimbank City Council"),
      SPEARScraper.new("Cardinia Shire Council", "Cardinia", "VIC", "Cardinia Shire Council"),
      SPEARScraper.new("Casey City Council", "Casey", "VIC", "Casey City Council"),
      SPEARScraper.new("Central Goldfields Shire Council", "Central Goldfields", "VIC", "Central Goldfields Shire Council"),
      SPEARScraper.new("City of Greater Dandenong", "Dandenong", "VIC", "City of Greater Dandenong"),
      SPEARScraper.new("City of Greater Geelong", "Geelong", "VIC", "City of Greater Geelong"),
      SPEARScraper.new("Darebin City Council", "Darebin", "VIC", "Darebin City Council"),
      SPEARScraper.new("Frankston City Council", "Frankston", "VIC", "Frankston City Council"),
      SPEARScraper.new("Gannawarra Shire Council", "Gannawarra", "VIC", "Gannawarra Shire Council"),
      SPEARScraper.new("Glenelg Shire Council", "Glenelg", "VIC", "Glenelg Shire Council"),
      SPEARScraper.new("Golden Plains Shire Council", "Golden Plains", "VIC", "Golden Plains Shire Council"),
      SPEARScraper.new("Greater Shepparton City Council", "Shepparton", "VIC", "Greater Shepparton City Council"),
      SPEARScraper.new("Hepburn Shire Council", "Hepburn", "VIC", "Hepburn Shire Council"),
      SPEARScraper.new("Hobsons Bay City Council", "Hobsons Bay", "VIC", "Hobsons Bay City Council"),
      SPEARScraper.new("Manningham City Council", "Manningham", "VIC", "Manningham City Council"),
      SPEARScraper.new("Maroondah City Council", "Maroondah", "VIC", "Maroondah City Council"),
      # This one is a little strange. Need to see what we can sensibly call it
      SPEARScraper.new("Minister for Planning", "Victoria", "VIC", "Minister for Planning"),
      SPEARScraper.new("Mitchell Shire Council", "Mitchell", "VIC", "Mitchell Shire Council"),
      SPEARScraper.new("Moonee Valley City Council", "Moonee Valley", "VIC", "Moonee Valley City Council"),
      SPEARScraper.new("Moreland City Council", "Moreland", "VIC", "Moreland City Council"),
      SPEARScraper.new("Moyne Shire Council", "Moyne", "VIC", "Moyne Shire Council"),
      SPEARScraper.new("Port Phillip City Council", "Port Phillip", "VIC", "Port Phillip City Council"),
      SPEARScraper.new("Pyrenees Shire Council", "Pyrenees", "VIC", "Pyrenees Shire Council"),
      SPEARScraper.new("Shire of Melton", "Melton", "VIC", "Shire of Melton"),
      SPEARScraper.new("Southern Grampians Shire Council", "Southern Grampians", "VIC", "Southern Grampians Shire Council"),
      SPEARScraper.new("Surf Coast Shire Council", "Surf Coast", "VIC", "Surf Coast Shire Council"),
      SPEARScraper.new("Warrnambool City Council", "Warrnambool", "VIC", "Warrnambool City Council"),
      SPEARScraper.new("Wellington Shire Council", "Wellington", "VIC", "Wellington Shire Council"),
      SPEARScraper.new("Whittlesea City Council", "Whittlesea", "VIC", "Whittlesea City Council"),
      SPEARScraper.new("Wyndham City Council", "Wyndham", "VIC", "Wyndham City Council"),
      SPEARScraper.new("Yarra City Council", "Yarra", "VIC", "Yarra City Council"),
      CabooltureScraper.new("Caboolture District, Moreton Bay Regional Council", "Caboolture", "QLD"),
      PineRiversScraper.new("Pine Rivers District, Moreton Bay Regional Council", "Pine Rivers", "QLD"),
      RedcliffeScraper.new("Redcliffe District, Moreton Bay Regional Council", "Redcliffe", "QLD"),
      CaloundraScraper.new("Caloundra, Sunshine Coast Regional Council", "Caloundra", "QLD"),
      MaroochyScraper.new("Maroochydore and Nambour offices, Sunshine Coast Regional Council", "Maroochy", "QLD"),
      NoosaScraper.new("Noosa, Sunshine Coast Regional Council", "Noosa", "QLD"),
      BlacktownScraper.new("Blacktown City Council", "Blacktown", "NSW"),
      SydneyScraper.new("City of Sydney", "Sydney", "NSW"),
      LoganScraper.new("Logan City Council", "Logan", "QLD"),
      WoollahraScraper.new("Woollahra Municipal Council", "Woollahra", "NSW"),
      RandwickScraper.new("Randwick City Council", "Randwick", "NSW"),
      SutherlandScraper.new("Sutherland Shire Council", "Sutherland", "NSW"),
      ACTScraper.new("ACT Planning & Land Authority", "ACT", "ACT"),
      MosmanScraper.new("Mosman Municipal Council", "Mosman", "NSW"),
      # There are two websites that we're getting data for Melbourne City Council from.
      # Using "Melbourne (City)" to disambiguate from the "Melbourne" used by the SPEAR scraper.
      SPEARScraper.new("Melbourne City Council (SPEAR)", "Melbourne", "VIC", "Melbourne City Council"),
      MelbourneScraper.new("Melbourne City Council", "Melbourne (City)", "VIC"),
      WollongongScraper.new("Wollongong City Council", "Wollongong", "NSW"),
    ]
  end
  
  def self.scraper_factory(name)
    scrapers.find{|p| p.planning_authority_short_name_encoded == name}
  end
end
