$:.unshift "#{File.dirname(__FILE__)}/../../"

require 'spec'
require 'scraper_factory'

describe PineRiversScraper do
  it "should return a particular expected planning application for a particular day" do
    date = Date.new(2009, 11, 12)
    results = Scrapers::scraper_factory("pine_rivers").applications(date)
    results.size.should == 3
    
    results.first.should == DevelopmentApplication.new(
      :application_id => "2009/12367/MCU",
      :description => "MATERIAL CHANGE OF USE - DEVELOPMENT PERMIT (DUPLEX)",
      :date_received => date,
      :address => "1 Bottle Tree Crescent\nMANGO HILL  4509\nQLD",
      :info_url => "http://pdonline-pinerivers.moretonbay.qld.gov.au/modules/applicationmaster/default.aspx?page=found&7=12367&8=2009",
      :comment_url => "mailto:developmentservices@pinerivers.qld.gov.au?subject=Development%20Application%20Enquiry:%202009/12367/MCU%20-%20MATERIAL%20CHANGE%20OF%20USE%20-%20DEVELOPMENT%20PERMIT%20(DUPLEX)&Body="
    )
  end
end


