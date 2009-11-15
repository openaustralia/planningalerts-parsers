$:.unshift "#{File.dirname(__FILE__)}/../"
require 'spec'

require 'development_application'

describe DevelopmentApplication do
  it "should automatically parse a text date" do
    da = DevelopmentApplication.new(:on_notice_from => "12 Nov 2009", :on_notice_to => "1 January 2010")
    da.on_notice_from.should == Date.new(2009, 11, 12)
    da.on_notice_to.should == Date.new(2010, 1, 1)
  end
  
  it "should handle the dates not being set" do
    da = DevelopmentApplication.new
    da.on_notice_from.should be_nil
    da.on_notice_to.should be_nil
  end
  
  it "should barf when trying to use an unknown key in the initializer" do
    lambda{DevelopmentApplication.new(:foo => "bar")}.should raise_error(RuntimeError, "Unexpected keys foo used")
  end
  
  it "should handle some standard keys" do
    da = DevelopmentApplication.new(:application_id => "1234", :address => "12a Smith Street",
      :description => "Lawn extension")
    da.application_id.should == "1234"
    da.address.should == "12a Smith Street"
    da.description.should == "Lawn extension"
  end
  
  it "should be able to output as XML" do
    da = DevelopmentApplication.new(:application_id => "1234", :address => "12a Smith Street",
      :description => "Lawn extension", :on_notice_from => "10 April 2009", :on_notice_to => "24 April 2009")
    # For the time being do not output any of the "on notice" information because I'm not sure how it relates
    # to the "date received" information used by planningalerts.com
    da.to_xml.should == <<-EOF
<application>
  <council_reference>1234</council_reference>
  <address>12a Smith Street</address>
  <description>Lawn extension</description>
</application>
    EOF
  end
end
