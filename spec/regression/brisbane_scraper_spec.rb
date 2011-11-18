$:.unshift "#{File.dirname(__FILE__)}/../.."

require 'scraper_factory'

describe BrisbaneScraper do
  it "should return a particular expected planning application for a particular day" do
    date = Date.new(2009, 11, 12)
    Scrapers::scraper_factory("brisbane").applications(date).should include(DevelopmentApplication.new(
      :application_id => "A002473914",
      :description => "House in DCP (Demolition/Extension), House in DCP (Demolition/Extension)",
      :address => "108 ORIEL RD CLAYFIELD QLD 4011",
      :info_url => "http://pdonline.brisbane.qld.gov.au/MasterView/modules/applicationmaster/default.aspx?page=wrapper&key=A002473914",
      :comment_url => "https://obonline.ourbrisbane.com/services/startDASubmission.do?direct=true&daNumber=A002473914&sdeprop=108%20ORIEL%20RD%20CLAYFIELD%20QLD%204011",
      :date_received => date
    ))
  end
end

