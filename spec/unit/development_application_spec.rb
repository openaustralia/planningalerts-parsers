$:.unshift "#{File.dirname(__FILE__)}/../../lib"
require 'development_application'

describe DevelopmentApplication do
  before(:each) do
    @da = DevelopmentApplication.new(:application_id => "1234", :address => "12a Smith Street",
      :description => "Lawn extension", :on_notice_from => "12 Nov 2009", :on_notice_to => "1 January 2010",
      :info_url => "http://foo.nsw.gov.au/aplications/1234", :comment_url => "http://foo.nsw.gov.au/comment/1234",
      :date_received => "1 Feb 2009")    
  end

  it "should automatically parse a text date" do
    @da.on_notice_from.should == Date.new(2009, 11, 12)
    @da.on_notice_to.should == Date.new(2010, 1, 1)
    @da.date_received.should == Date.new(2009, 2, 1)
  end
  
  it "should automatically parse the url parameters" do
    @da.info_url.should == URI.parse("http://foo.nsw.gov.au/aplications/1234")
    @da.comment_url.should == URI.parse("http://foo.nsw.gov.au/comment/1234")
  end
  
  it "should parse the url parameters when set through the accessors too" do
    @da.info_url = "http://blah.com"
    @da.info_url.should == URI.parse("http://blah.com")
  end
  
  it "should be able to cope with a URI object being used to set the url as well" do
    @da.info_url = URI.parse("http://blah.com")
    @da.info_url.should == URI.parse("http://blah.com")    
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
  <date_received>2009-02-01</date_received>
  <on_notice_from>2009-11-12</on_notice_from>
  <on_notice_to>2010-01-01</on_notice_to>
</application>
    EOF
  end
end

describe DevelopmentApplication, "multiple addresses" do
  it "should be able to store multiple addresses" do
    DevelopmentApplication.new(:addresses => ["First", "Second"]).addresses.should == ["First", "Second"]
  end
  
  it "should be able to set a single address using addresses too" do
    DevelopmentApplication.new(:addresses => ["Address"]).address.should == "Address"
  end
  
  it "should be able to get a single address using addresses too" do
    DevelopmentApplication.new(:address => "Address").addresses.should == ["Address"]
  end
  
  it "should error when trying to retrieve a single address when there are multiple" do
    da = DevelopmentApplication.new(:addresses => ["First", "Second"])
    lambda{da.address}.should raise_error(RuntimeError, "Can not use address when there are several addresses")
  end
  
  it "should output multiple applications in xml when there are multiple addresses" do
    da = DevelopmentApplication.new(:application_id => "27B/6", :description => "foo", :addresses => ["First", "Second"])
    da.to_xml.to_s.should == <<-EOF
<application>
  <council_reference>27B/6</council_reference>
  <address>First</address>
  <description>foo</description>
  <info_url></info_url>
  <comment_url></comment_url>
  <date_received></date_received>
</application>
<application>
  <council_reference>27B/6</council_reference>
  <address>Second</address>
  <description>foo</description>
  <info_url></info_url>
  <comment_url></comment_url>
  <date_received></date_received>
</application>
    EOF
  end
end
