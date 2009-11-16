$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'spec'

require 'simple_struct'

describe SimpleStruct do
  it "should accept attribute values as a hash" do
    c = SimpleStruct :foo, :bar
    a = c.new(:foo => "fiddle", :bar => "sticks")
    a.foo.should == "fiddle"
    a.bar.should == "sticks"
  end
  
  it "should allow the attributes to be changed" do
    c = SimpleStruct :foo, :bar
    a = c.new(:foo => "fiddle", :bar => "sticks")
    a.foo = "bar"
    a.foo.should == "bar"
  end
end