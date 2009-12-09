$:.unshift "#{File.dirname(__FILE__)}/../../"

require 'spec'
require 'scraper_factory'

describe MaroochyScraper do
  it "should return a particular expected planning application for a particular day" do
    date = Date.new(2009, 11, 11)
    results = Scrapers::scraper_factory("maroochy").applications(date)
    results.size.should == 15
    
    results.first.should == DevelopmentApplication.new(
      :application_id => "OPW09/0282",
      :description => "Description: Parklakes Sports Reserve Yandina Bli Bli Road Bli Bli - Landscaping for stormwater treatment facility and sports reserve - Covey & Associates",
      :date_received => date,
      :address => "0 /\n\n\t\t\t\t\t\t   0 Camp Flat Rd, BLI BLI\nQLD",
      :info_url => "http://pdonline.maroochy.qld.gov.au/modules/applicationmaster/default.aspx?page=found&7=OPW09/0282&8=",
      :comment_url => "http://pdonline.maroochy.qld.gov.au/modules/applicationmaster/default.aspx?page=found&7=OPW09/0282&8="
    )
  end
end



