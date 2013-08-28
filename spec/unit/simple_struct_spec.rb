require 'spec_helper'

describe SimpleStruct do
  before(:each) do
    @c = Class.new(SimpleStruct)
    @c.add_attributes :foo, :bar
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
    class D < SimpleStruct; end
    lambda{D.new(:diddle => "bar")}.should raise_error(RuntimeError, "Unexpected attribute diddle used")    
  end
  
  it "should return a list of attributes" do
    @c.attributes.should == [:foo, :bar]
  end

  it "should be equal to another SimpleStruct with the same fields" do
    class D < SimpleStruct
      add_attributes :foo, :bar
    end
    @c.new(:foo => "fiddle", :bar => "sticks").should == D.new(:foo => "fiddle", :bar => "sticks")
  end
  
  it "should not be equal to an object of another type" do
    @c.new(:foo => "fiddle", :bar => "sticks").should_not == "a random string for instance"
  end
  
  it "should handle nothing being set" do
    a = @c.new
    a.foo.should be_nil
    a.bar.should be_nil
  end
  
  it "should be able add new attributes by using add_attributes" do
    @c.add_attributes(:boo, :bibble)
    @c.attributes.should == [:foo, :bar, :boo, :bibble]
    a = @c.new(:boo => "blah")
    a.boo.should == "blah"
  end
  
  it "should inherit the attributes from its parent" do
    d = Class.new(@c)
    d.add_attributes(:biddle)
    d.attributes.should == [:foo, :bar, :biddle]
  end
end
