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
      # TODO: Figure out which of these authorities using the SPEAR system have planning information
      # in the system and which just have subdivision information
      SPEARScraper.new("Ararat Rural City Council", "Ararat", "Ararat Rural City Council"),
      SPEARScraper.new("Ballarat City Council", "Ballarat", "Ballarat City Council"),
      SPEARScraper.new("Banyule City Council", "Banyule", "Banyule City Council"),
      SPEARScraper.new("Boroondara City Council", "Boroondara", "Boroondara City Council"),
      SPEARScraper.new("Brimbank City Council", "Brimbank", "Brimbank City Council"),
      SPEARScraper.new("Cardinia Shire Council", "Cardinia", "Cardinia Shire Council"),
      SPEARScraper.new("Casey City Council", "Casey", "Casey City Council"),
      SPEARScraper.new("Central Goldfields Shire Council", "Central Goldfields", "Central Goldfields Shire Council"),
      SPEARScraper.new("City of Greater Dandenong", "Dandenong", "City of Greater Dandenong"),
      SPEARScraper.new("City of Greater Geelong", "Geelong", "City of Greater Geelong"),
      SPEARScraper.new("Darebin City Council", "Darebin", "Darebin City Council"),
      SPEARScraper.new("Frankston City Council", "Frankston", "Frankston City Council"),
      SPEARScraper.new("Gannawarra Shire Council", "Gannawarra", "Gannawarra Shire Council"),
      SPEARScraper.new("Glenelg Shire Council", "Glenelg", "Glenelg Shire Council"),
      SPEARScraper.new("Golden Plains Shire Council", "Golden Plains", "Golden Plains Shire Council"),
      SPEARScraper.new("Greater Shepparton City Council", "Shepparton", "Greater Shepparton City Council"),
      SPEARScraper.new("Hepburn Shire Council", "Hepburn", "Hepburn Shire Council"),
      SPEARScraper.new("Hobsons Bay City Council", "Hobsons Bay", "Hobsons Bay City Council"),
      SPEARScraper.new("Manningham City Council", "Manningham", "Manningham City Council"),
      SPEARScraper.new("Maroondah City Council", "Maroondah", "Maroondah City Council"),
      SPEARScraper.new("Melbourne City Council", "Melbourne", "Melbourne City Council"),
      # This one is a little strange. Need to see what we can sensibly call it
      SPEARScraper.new("Victoria (Minister for Planning)", "Victoria", "Minister for Planning"),
      SPEARScraper.new("Mitchell Shire Council", "Mitchell", "Mitchell Shire Council"),
      SPEARScraper.new("Moonee Valley City Council", "Moonee Valley", "Moonee Valley City Council"),
      SPEARScraper.new("Moreland City Council", "Moreland", "Moreland City Council"),
      SPEARScraper.new("Moyne Shire Council", "Moyne", "Moyne Shire Council"),
      SPEARScraper.new("Port Phillip City Council", "Port Phillip", "Port Phillip City Council"),
      SPEARScraper.new("Pyrenees Shire Council", "Pyrenees", "Pyrenees Shire Council"),
      SPEARScraper.new("Shire of Melton", "Melton", "Shire of Melton"),
      SPEARScraper.new("Southern Grampians Shire Council", "Southern Grampians", "Southern Grampians Shire Council"),
      SPEARScraper.new("Surf Coast Shire Council", "Surf Coast", "Surf Coast Shire Council"),
      SPEARScraper.new("Warrnambool City Council", "Warrnambool", "Warrnambool City Council"),
      SPEARScraper.new("Wellington Shire Council", "Wellington", "Wellington Shire Council"),
      SPEARScraper.new("Whittlesea City Council", "Whittlesea", "Whittlesea City Council"),
      SPEARScraper.new("Wyndham City Council", "Wyndham", "Wyndham City Council"),
      SPEARScraper.new("Yarra City Council", "Yarra", "Yarra City Council"),
    ]
  end
  
  def self.scraper_factory(name)
    scrapers.find{|p| p.planning_authority_short_name_encoded == name}
  end
end
