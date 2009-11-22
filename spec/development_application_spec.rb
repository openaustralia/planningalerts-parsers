$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'spec'

require 'development_application'

describe DevelopmentApplication do
  before(:each) do
    @da = DevelopmentApplication.new(:application_id => "1234", :address => "12a Smith Street",
      :description => "Lawn extension", :on_notice_from => "12 Nov 2009", :on_notice_to => "1 January 2010",
      :info_url => "http://foo.nsw.gov.au/aplications/1234", :comment_url => "http://foo.nsw.gov.au/comment/1234")    
  end

  it "should automatically parse a text date" do
    @da.on_notice_from.should == Date.new(2009, 11, 12)
    @da.on_notice_to.should == Date.new(2010, 1, 1)
  end
  
  it "should automatically parse the url parameters" do
    @da.info_url.should == URI.parse("http://foo.nsw.gov.au/aplications/1234")
    @da.comment_url.should == URI.parse("http://foo.nsw.gov.au/comment/1234")
  end
  
  it "should parse the url parameters when set through the accessors too" do
    @da.info_url = "http://blah.com"
    @da.info_url.should == URI.parse("http://blah.com")
  end
  
  it "should handle the dates not being set" do
    da = DevelopmentApplication.new
    da.on_notice_from.should be_nil
    da.on_notice_to.should be_nil
  end
  
  it "should handle some other standard keys" do
    @da.application_id.should == "1234"
    @da.address.should == "12a Smith Street"
    @da.description.should == "Lawn extension"
  end
  
  it "should be able to output as XML" do
    # For the time being do not output any of the "on notice" information because I'm not sure how it relates
    # to the "date received" information used by planningalerts.com
    @da.to_xml.should == <<-EOF
<application>
  <council_reference>1234</council_reference>
  <address>12a Smith Street</address>
  <description>Lawn extension</description>
  <info_url>http://foo.nsw.gov.au/aplications/1234</info_url>
  <comment_url>http://foo.nsw.gov.au/comment/1234</comment_url>
</application>
    EOF
  end
end
