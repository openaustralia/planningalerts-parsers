$:.unshift "#{File.dirname(__FILE__)}/../../"

require 'spec'
require 'scraper_factory'

describe RedcliffeScraper do
  it "should return a particular expected planning application for a particular day" do
    date = Date.new(2009, 11, 11)
    results = Scrapers::scraper_factory("redcliffe").applications(date)
    results.size.should == 2
    
    results.first.should == DevelopmentApplication.new(
      :application_id => "35OPW -257/2009",
      :description => "Description: Operational Works - Development Permit for Boat Ramp, Boardwalk & Platform",
      :date_received => date,
      :address => "57 Australia Court NEWPORT 4020, QLD",
      :info_url => "http://pdonline.redcliffe.qld.gov.au/modules/applicationMaster/default.aspx?page=found&7=257&8=2009",
      :comment_url => "http://pdonline.redcliffe.qld.gov.au/modules/applicationMaster/default.aspx?page=found&7=257&8=2009"
    )
  end
end


