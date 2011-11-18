$:.unshift "#{File.dirname(__FILE__)}/../../"

require 'scraper_factory'

describe NoosaScraper do
  it "should return a particular expected planning application for a particular day" do
    date = Date.new(2009, 11, 11)
    results = Scrapers::scraper_factory("noosa").applications(date)
    results.size.should == 1
    
    results.first.should == DevelopmentApplication.new(
      :application_id => "2009 / 1584",
      :description => "09/1584 Reconfiguration of a Lot (1 into 2)",
      :date_received => date,
      :address => "13 Amaroo PL, COOROIBAH, QLD",
      :info_url => "http://rrif.noosa.qld.gov.au/masterviewpublic/modules/applicationmaster/default.aspx?page=found&4a=16,12,15,13,14,18,17&7=1584&8=2009",
      :comment_url => "http://rrif.noosa.qld.gov.au/masterviewpublic/modules/applicationmaster/default.aspx?page=found&4a=16,12,15,13,14,18,17&7=1584&8=2009"
    )
  end
  
  it "should return no applications on a day when there were no applications" do
    date = Date.new(2009, 12, 9)
    results = Scrapers::scraper_factory("noosa").applications(date)
    results.size.should == 0
  end
end
