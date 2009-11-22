$:.unshift "#{File.dirname(__FILE__)}/../../lib"
$:.unshift "#{File.dirname(__FILE__)}/../../scrapers"

require 'rubygems'
require 'spec'
require 'brisbane_scraper'
require 'blue_mountains_scraper'
require 'gold_coast_scraper'

describe BrisbaneScraper do
  it "should know its name" do
    BrisbaneScraper.planning_authority_name.should == "Brisbane City Council"
    BrisbaneScraper.planning_authority_short_name.should == "Brisbane"    
  end
end

describe BlueMountainsScraper do
  it "should know its name" do
    BlueMountainsScraper.planning_authority_name.should == "Blue Mountains City Council"
    BlueMountainsScraper.planning_authority_short_name.should == "Blue Mountains"    
  end
end

describe GoldCoastScraper do
  it "should know its name" do
    GoldCoastScraper.planning_authority_name.should == "Gold Coast City Council"
    GoldCoastScraper.planning_authority_short_name.should == "Gold Coast"    
  end
end

