$:.unshift "#{File.dirname(__FILE__)}/../../lib"
require 'spec'
require 'info_master_scraper'

describe InfoMasterScraper do
  before(:each) do
    @s = InfoMasterScraper.new("long", "short", "state") 
  end
  
  it "should not split a line along newlines" do
    @s.split_lines(Nokogiri.parse("<td>a\nb</td>").at('td')).should == ["a\nb"]
  end
  
  it "should throw aways html tags" do
    @s.split_lines(Nokogiri.parse("<td><b>this is bold</b> and this isn't</td>").at('td')).should == ["this is bold and this isn't"]    
  end
  
  it "should break along a <br/> tag" do
    @s.split_lines(Nokogiri.parse("<td>a<br/>b</td>").at('td')).should == ["a", "b"]
  end
  
  it "should convert html entities" do
    @s.split_lines(Nokogiri.parse("<td>a&amp;b</td>").at('td')).should == ["a&b"]
  end
end