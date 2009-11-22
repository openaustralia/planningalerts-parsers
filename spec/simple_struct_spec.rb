$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'spec'

require 'simple_struct'

describe SimpleStruct do
  before(:each) do
    @c = SimpleStruct :foo, :bar
  end
  
  it "should accept attribute values as a hash" do
    a = @c.new(:foo => "fiddle", :bar => "sticks")
    a.foo.should == "fiddle"
    a.bar.should == "sticks"
  end
  
  it "should allow the attributes to be changed" do
    a = @c.new(:foo => "fiddle", :bar => "sticks")
    a.foo = "bar"
    a.foo.should == "bar"
  end
  
  it "should barf when trying to use an unknown key in the initializer" do
    lambda{@c.new(:diddle => "bar")}.should raise_error(RuntimeError, "Unexpected attribute diddle used")
  end
  
  it "should return a list of attributes" do
    @c.new(:foo => "fiddle", :bar => "sticks").attributes.should == [:foo, :bar]
  end

  it "should be equal to another SimpleStruct with the same fields" do
    d = SimpleStruct :foo, :bar
    @c.new(:foo => "fiddle", :bar => "sticks").should == d.new(:foo => "fiddle", :bar => "sticks")
  end
  
  it "should not be equal to an object of another type" do
    @c.new(:foo => "fiddle", :bar => "sticks").should_not == "a random string for instance"
  end
end