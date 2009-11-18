$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'parser_server'
require 'spec'
require 'rack/test'
require 'sinatra'

describe "Server for parser XML" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "should retrieve the Blue Mountains data" do
    r = mock("PlanningAuthorityResults")
    r.stub!(:to_xml).and_return("foo")
    p = mock("BlueMountainsParser")
    p.stub!(:applications).and_return(r)
    BlueMountainsParser.stub!(:new).and_return(p)
    get "/blue_mountains"
    last_response.body.should == "foo"
  end
end