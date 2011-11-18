$:.unshift "#{File.dirname(__FILE__)}/../../"

require 'scraper_factory'

describe CaloundraScraper do
  it "should return a particular expected planning application for a particular day" do
    date = Date.new(2009, 11, 11)
    results = Scrapers::scraper_factory("caloundra").applications(date)
    results.size.should == 2
    
    results.first.should == DevelopmentApplication.new(
      :application_id => "2009/55-00050",
      :description => "Change to Development Approval - Extension of Relevent Period", 
      :date_received => date,
      :address => "72 Caloundra Rd, Caloundra, QLD",
      :info_url => "http://pdonline.caloundra.qld.gov.au/modules/applicationmaster/default.aspx?page=found&7=55-00050&8=2009",
      :comment_url => "http://pdonline.caloundra.qld.gov.au/modules/applicationmaster/default.aspx?page=found&7=55-00050&8=2009"
    )
  end
  
  it "should return no applications on a day when there were no applications" do
    date = Date.new(2009, 12, 9)
    results = Scrapers::scraper_factory("caloundra").applications(date)
    results.size.should == 0
  end
end


