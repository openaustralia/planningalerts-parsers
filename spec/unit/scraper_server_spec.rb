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
  
  before(:each) do
    @blue_mountains = BlueMountainsScraper.new("Blue Mountains City Council", "Blue Mountains", "NSW")
    @brisbane = BrisbaneScraper.new("Brisbane City Council", "Brisbane", "QLD")
    # Restrict parsers to just two
    Scrapers.stub!(:scrapers).and_return([@blue_mountains, @brisbane])
    @results = mock("PlanningAuthorityResults")
  end
  
  it "should append the name of the state to the end of the long name" do
    @brisbane.planning_authority_name.should == "Brisbane City Council, QLD"
  end

  it "should retrieve the Blue Mountains data" do
    @results.should_receive(:to_xml).and_return("foo")
    @blue_mountains.should_receive(:results).with(Date.new(2009,11,12)).and_return(@results)
    get "/blue_mountains?year=2009&month=11&day=12"
    last_response.body.should == "foo"
  end

  it "should retrieve the Brisbane data" do
    @results.should_receive(:to_xml).and_return("foo")
    @brisbane.should_receive(:results).with(Date.new(2009,11,12)).and_return(@results)
    get "/brisbane?year=2009&month=11&day=12"
    last_response.body.should == "foo"
  end
  
  it "should retrieve a list of all the scraper urls" do
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
  
  it "should return a blank document if a invalid date is given" do
    get "/brisbane"
    last_response.body.should == ""
  end
end