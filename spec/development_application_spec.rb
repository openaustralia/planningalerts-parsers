require 'spec'

require 'development_application'

describe DevelopmentApplication do
  it "should automatically parse a text date" do
    da = DevelopmentApplication.new(:from => "12 Nov 2009", :to => "1 January 2010")
    da.from.should == Date.new(2009, 11, 12)
    da.to.should == Date.new(2010, 1, 1)
  end
  
  it "should handle the dates not being set" do
    da = DevelopmentApplication.new
    da.from.should be_nil
    da.to.should be_nil
  end
  
  it "should barf when trying to use an unknown key in the initializer" do
    lambda{DevelopmentApplication.new(:foo => "bar")}.should raise_error(RuntimeError, "Unexpected keys foo used")
  end
end