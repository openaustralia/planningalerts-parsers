$:.unshift "#{File.dirname(__FILE__)}/../../lib"
$:.unshift "#{File.dirname(__FILE__)}/../.."

require 'scraper_server'
require 'spec'
require 'rack/test'
require 'sinatra'

describe "Server for scraper XML" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "should retrieve the Blue Mountains data" do
    r = mock("PlanningAuthorityResults")
    p = BlueMountainsScraper.new
    r.should_receive(:to_xml).and_return("foo")
    p.should_receive(:results).with(Date.new(2009,11,12)).and_return(r)
    BlueMountainsScraper.stub!(:new).and_return(p)
    get "/blue_mountains?year=2009&month=11&day=12"
    last_response.body.should == "foo"
  end

  it "should retrieve the Brisbane data" do
    r = mock("PlanningAuthorityResults")
    p = BrisbaneScraper.new
    r.should_receive(:to_xml).and_return("foo")
    p.should_receive(:results).with(Date.new(2009,11,12)).and_return(r)
    BrisbaneScraper.stub!(:new).and_return(p)
    get "/brisbane?year=2009&month=11&day=12"
    last_response.body.should == "foo"
  end
  
  it "should retrieve a list of all the scraper urls" do
    # Restrict parsers to just two
    Scrapers.stub!(:scrapers).and_return([BlueMountainsScraper.new, BrisbaneScraper.new])
    get "/"
    last_response.body.should == <<-EOF
<scrapers>
  <scraper>
    <authority_name>Blue Mountains City Council, NSW</authority_name>
    <authority_short_name>Blue Mountains</authority_short_name>
    <url>http://example.org/blue_mountains?year={year}&amp;month={month}&amp;day={day}</url>
  </scraper>
  <scraper>
    <authority_name>Brisbane City Council, QLD</authority_name>
    <authority_short_name>Brisbane</authority_short_name>
    <url>http://example.org/brisbane?year={year}&amp;month={month}&amp;day={day}</url>
  </scraper>
</scrapers>
    EOF
  end
end