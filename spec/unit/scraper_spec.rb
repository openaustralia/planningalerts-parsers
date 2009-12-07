$:.unshift "#{File.dirname(__FILE__)}/../../lib"
$:.unshift "#{File.dirname(__FILE__)}/../../scrapers"

require 'rubygems'
require 'spec'
require 'brisbane_scraper'
require 'blue_mountains_scraper'
require 'gold_coast_scraper'

describe BrisbaneScraper do
  it "should know its name" do
    s = BrisbaneScraper.new
    s.planning_authority_name.should == "Brisbane City Council, QLD"
    s.planning_authority_short_name.should == "Brisbane"    
  end
end

describe BlueMountainsScraper do
  it "should know its name" do
    s = BlueMountainsScraper.new
    s.planning_authority_name.should == "Blue Mountains City Council, NSW"
    s.planning_authority_short_name.should == "Blue Mountains"    
  end
end

describe GoldCoastScraper do
  it "should know its name" do
    s = GoldCoastScraper.new
    s.planning_authority_name.should == "Gold Coast City Council, QLD"
    s.planning_authority_short_name.should == "Gold Coast"    
  end
end

