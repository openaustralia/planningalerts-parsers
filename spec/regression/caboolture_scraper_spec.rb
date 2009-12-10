$:.unshift "#{File.dirname(__FILE__)}/../../"

require 'spec'
require 'scraper_factory'

describe CabooltureScraper do
  it "should return a particular expected planning application for a particular day" do
    date = Date.new(2009, 11, 12)
    results = Scrapers::scraper_factory("caboolture").applications(date)
    results.size.should == 4
    
    results.first.should == DevelopmentApplication.new(
      :application_id => "CDE-2288/2009",
      :description => "Material Change of Use - Development Permit for Dependent Person's Accommodation",
      :date_received => date,
      :address => "23 Sumar Lane BELLMERE, QLD",
      :info_url => "http://pdonline.caboolture.qld.gov.au/modules/applicationmaster/default.aspx?page=found&7=2288&8=2009",
      :comment_url => "http://pdonline.caboolture.qld.gov.au/modules/applicationmaster/default.aspx?page=found&7=2288&8=2009"
    )
  end
  
  it "should description" do
    
  end
end
