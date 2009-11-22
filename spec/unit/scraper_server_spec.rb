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
    p.should_receive(:applications).with(Date.new(2009,11,12)).and_return(r)
    BlueMountainsScraper.stub!(:new).and_return(p)
    get "/blue_mountains?year=2009&month=11&day=12"
    last_response.body.should == "foo"
  end

  it "should retrieve the Brisbane data" do
    r = mock("PlanningAuthorityResults")
    p = BrisbaneScraper.new
    r.should_receive(:to_xml).and_return("foo")
    p.should_receive(:applications).with(Date.new(2009,11,12)).and_return(r)
    BrisbaneScraper.stub!(:new).and_return(p)
    get "/brisbane?year=2009&month=11&day=12"
    last_response.body.should == "foo"
  end
end