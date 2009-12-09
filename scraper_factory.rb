$:.unshift "#{File.dirname(__FILE__)}/scrapers"

require 'blue_mountains_scraper'
require 'brisbane_scraper'
require 'gold_coast_scraper'
require 'spear_scraper'
require 'caboolture_scraper'
require 'pine_rivers_scraper'
require 'redcliffe_scraper'
require 'caloundra_scraper'
require 'maroochy_scraper'

module Scrapers
  # Central registry of scrapers
  def self.scrapers
    [BlueMountainsScraper.new("Blue Mountains City Council, NSW", "Blue Mountains", "NSW"),
      BrisbaneScraper.new("Brisbane City Council, QLD", "Brisbane", "QLD"),
      GoldCoastScraper.new("Gold Coast City Council, QLD", "Gold Coast", "QLD"),
      # TODO: Figure out which of these authorities using the SPEAR system have planning information
      # in the system and which just have subdivision information
      SPEARScraper.new("Ararat Rural City Council, VIC", "Ararat", "VIC", "Ararat Rural City Council"),
      SPEARScraper.new("Ballarat City Council, VIC", "Ballarat", "VIC", "Ballarat City Council"),
      SPEARScraper.new("Banyule City Council, VIC", "Banyule", "VIC", "Banyule City Council"),
      SPEARScraper.new("Boroondara City Council, VIC", "Boroondara", "VIC", "Boroondara City Council"),
      SPEARScraper.new("Brimbank City Council, VIC", "Brimbank", "VIC", "Brimbank City Council"),
      SPEARScraper.new("Cardinia Shire Council, VIC", "Cardinia", "VIC", "Cardinia Shire Council"),
      SPEARScraper.new("Casey City Council, VIC", "Casey", "VIC", "Casey City Council"),
      SPEARScraper.new("Central Goldfields Shire Council, VIC", "Central Goldfields", "VIC", "Central Goldfields Shire Council"),
      SPEARScraper.new("City of Greater Dandenong, VIC", "Dandenong", "VIC", "City of Greater Dandenong"),
      SPEARScraper.new("City of Greater Geelong, VIC", "Geelong", "VIC", "City of Greater Geelong"),
      SPEARScraper.new("Darebin City Council, VIC", "Darebin", "VIC", "Darebin City Council"),
      SPEARScraper.new("Frankston City Council, VIC", "Frankston", "VIC", "Frankston City Council"),
      SPEARScraper.new("Gannawarra Shire Council, VIC", "Gannawarra", "VIC", "Gannawarra Shire Council"),
      SPEARScraper.new("Glenelg Shire Council, VIC", "Glenelg", "VIC", "Glenelg Shire Council"),
      SPEARScraper.new("Golden Plains Shire Council, VIC", "Golden Plains", "VIC", "Golden Plains Shire Council"),
      SPEARScraper.new("Greater Shepparton City Council, VIC", "Shepparton", "VIC", "Greater Shepparton City Council"),
      SPEARScraper.new("Hepburn Shire Council, VIC", "Hepburn", "VIC", "Hepburn Shire Council"),
      SPEARScraper.new("Hobsons Bay City Council, VIC", "Hobsons Bay", "VIC", "Hobsons Bay City Council"),
      SPEARScraper.new("Manningham City Council, VIC", "Manningham", "VIC", "Manningham City Council"),
      SPEARScraper.new("Maroondah City Council, VIC", "Maroondah", "VIC", "Maroondah City Council"),
      SPEARScraper.new("Melbourne City Council, VIC", "Melbourne", "VIC", "Melbourne City Council"),
      # This one is a little strange. Need to see what we can sensibly call it
      SPEARScraper.new("Minister for Planning, VIC", "Victoria", "VIC", "Minister for Planning"),
      SPEARScraper.new("Mitchell Shire Council, VIC", "Mitchell", "VIC", "Mitchell Shire Council"),
      SPEARScraper.new("Moonee Valley City Council, VIC", "Moonee Valley", "VIC", "Moonee Valley City Council"),
      SPEARScraper.new("Moreland City Council, VIC", "Moreland", "VIC", "Moreland City Council"),
      SPEARScraper.new("Moyne Shire Council, VIC", "Moyne", "VIC", "Moyne Shire Council"),
      SPEARScraper.new("Port Phillip City Council, VIC", "Port Phillip", "VIC", "Port Phillip City Council"),
      SPEARScraper.new("Pyrenees Shire Council, VIC", "Pyrenees", "VIC", "Pyrenees Shire Council"),
      SPEARScraper.new("Shire of Melton, VIC", "Melton", "VIC", "Shire of Melton"),
      SPEARScraper.new("Southern Grampians Shire Council, VIC", "Southern Grampians", "VIC", "Southern Grampians Shire Council"),
      SPEARScraper.new("Surf Coast Shire Council, VIC", "Surf Coast", "VIC", "Surf Coast Shire Council"),
      SPEARScraper.new("Warrnambool City Council, VIC", "Warrnambool", "VIC", "Warrnambool City Council"),
      SPEARScraper.new("Wellington Shire Council, VIC", "Wellington", "VIC", "Wellington Shire Council"),
      SPEARScraper.new("Whittlesea City Council, VIC", "Whittlesea", "VIC", "Whittlesea City Council"),
      SPEARScraper.new("Wyndham City Council, VIC", "Wyndham", "VIC", "Wyndham City Council"),
      SPEARScraper.new("Yarra City Council, VIC", "Yarra", "VIC", "Yarra City Council"),
      CabooltureScraper.new("Caboolture District, Moreton Bay Regional Council, QLD", "Caboolture", "QLD"),
      PineRiversScraper.new("Pine Rivers District, Moreton Bay Regional Council, QLD", "Pine Rivers", "QLD"),
      RedcliffeScraper.new("Redcliffe District, Moreton Bay Regional Council, QLD", "Redcliffe", "QLD"),
      CaloundraScraper.new("Caloundra, Sunshine Coast Regional Council, QLD", "Caloundra", "QLD"),
      MaroochyScraper.new("Maroochydore and Nambour offices, Sunshine Coast Regional Council, QLD", "Maroochy", "QLD"),
    ]
  end
  
  def self.scraper_factory(name)
    scrapers.find{|p| p.planning_authority_short_name_encoded == name}
  end
end
