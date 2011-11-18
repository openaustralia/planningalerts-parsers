$:.unshift "#{File.dirname(__FILE__)}/../../"

require 'scraper_factory'

describe GoldCoastScraper do
  it "should return a particular expected planning application for a particular day" do
    date = Date.new(2009, 11, 2)
    results = Scrapers::scraper_factory("gold_coast").applications(date)
    results.size.should == 2
    results.first.should == DevelopmentApplication.new(
      :application_id => "MCU2900729",
      :description => "Description: ATTACHED DWELLING - ADDITIONS\nClass: CODE\nWork Type:",
      :date_received => date,
      :address => "46 NOBBY PARADE, MIAMI 4220, QLD",
      :info_url => "http://pdonline.goldcoast.qld.gov.au/masterview/modules/applicationmaster/default.aspx?page=found&4a=MCU&7=2900729",
      :comment_url => "http://pdonline.goldcoast.qld.gov.au/masterview/modules/applicationmaster/default.aspx?page=found&4a=MCU&7=2900729"
    )
  end
end

