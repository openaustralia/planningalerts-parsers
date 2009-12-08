$:.unshift "#{File.dirname(__FILE__)}/scrapers"

require 'blue_mountains_scraper'
require 'brisbane_scraper'
require 'gold_coast_scraper'
require 'spear_scraper'
require 'caboolture_scraper'
require 'pine_rivers_scraper'

module Scrapers
  # Central registry of scrapers
  def self.scrapers
    [BlueMountainsScraper.new,
      BrisbaneScraper.new,
      GoldCoastScraper.new,
      # TODO: Figure out which of these authorities using the SPEAR system have planning information
      # in the system and which just have subdivision information
      SPEARScraper.new("Ararat Rural City Council, VIC", "Ararat", "Ararat Rural City Council"),
      SPEARScraper.new("Ballarat City Council, VIC", "Ballarat", "Ballarat City Council"),
      SPEARScraper.new("Banyule City Council, VIC", "Banyule", "Banyule City Council"),
      SPEARScraper.new("Boroondara City Council, VIC", "Boroondara", "Boroondara City Council"),
      SPEARScraper.new("Brimbank City Council, VIC", "Brimbank", "Brimbank City Council"),
      SPEARScraper.new("Cardinia Shire Council, VIC", "Cardinia", "Cardinia Shire Council"),
      SPEARScraper.new("Casey City Council, VIC", "Casey", "Casey City Council"),
      SPEARScraper.new("Central Goldfields Shire Council, VIC", "Central Goldfields", "Central Goldfields Shire Council"),
      SPEARScraper.new("City of Greater Dandenong, VIC", "Dandenong", "City of Greater Dandenong"),
      SPEARScraper.new("City of Greater Geelong, VIC", "Geelong", "City of Greater Geelong"),
      SPEARScraper.new("Darebin City Council, VIC", "Darebin", "Darebin City Council"),
      SPEARScraper.new("Frankston City Council, VIC", "Frankston", "Frankston City Council"),
      SPEARScraper.new("Gannawarra Shire Council, VIC", "Gannawarra", "Gannawarra Shire Council"),
      SPEARScraper.new("Glenelg Shire Council, VIC", "Glenelg", "Glenelg Shire Council"),
      SPEARScraper.new("Golden Plains Shire Council, VIC", "Golden Plains", "Golden Plains Shire Council"),
      SPEARScraper.new("Greater Shepparton City Council, VIC", "Shepparton", "Greater Shepparton City Council"),
      SPEARScraper.new("Hepburn Shire Council, VIC", "Hepburn", "Hepburn Shire Council"),
      SPEARScraper.new("Hobsons Bay City Council, VIC", "Hobsons Bay", "Hobsons Bay City Council"),
      SPEARScraper.new("Manningham City Council, VIC", "Manningham", "Manningham City Council"),
      SPEARScraper.new("Maroondah City Council, VIC", "Maroondah", "Maroondah City Council"),
      SPEARScraper.new("Melbourne City Council, VIC", "Melbourne", "Melbourne City Council"),
      # This one is a little strange. Need to see what we can sensibly call it
      SPEARScraper.new("Minister for Planning, VIC", "Victoria", "Minister for Planning"),
      SPEARScraper.new("Mitchell Shire Council, VIC", "Mitchell", "Mitchell Shire Council"),
      SPEARScraper.new("Moonee Valley City Council, VIC", "Moonee Valley", "Moonee Valley City Council"),
      SPEARScraper.new("Moreland City Council, VIC", "Moreland", "Moreland City Council"),
      SPEARScraper.new("Moyne Shire Council, VIC", "Moyne", "Moyne Shire Council"),
      SPEARScraper.new("Port Phillip City Council, VIC", "Port Phillip", "Port Phillip City Council"),
      SPEARScraper.new("Pyrenees Shire Council, VIC", "Pyrenees", "Pyrenees Shire Council"),
      SPEARScraper.new("Shire of Melton, VIC", "Melton", "Shire of Melton"),
      SPEARScraper.new("Southern Grampians Shire Council, VIC", "Southern Grampians", "Southern Grampians Shire Council"),
      SPEARScraper.new("Surf Coast Shire Council, VIC", "Surf Coast", "Surf Coast Shire Council"),
      SPEARScraper.new("Warrnambool City Council, VIC", "Warrnambool", "Warrnambool City Council"),
      SPEARScraper.new("Wellington Shire Council, VIC", "Wellington", "Wellington Shire Council"),
      SPEARScraper.new("Whittlesea City Council, VIC", "Whittlesea", "Whittlesea City Council"),
      SPEARScraper.new("Wyndham City Council, VIC", "Wyndham", "Wyndham City Council"),
      SPEARScraper.new("Yarra City Council, VIC", "Yarra", "Yarra City Council"),
      CabooltureScraper.new,
      PineRiversScraper.new,
    ]
  end
  
  def self.scraper_factory(name)
    scrapers.find{|p| p.planning_authority_short_name_encoded == name}
  end
end
