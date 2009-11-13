require 'spec'

require 'planning_authority_results'

describe PlanningAuthorityResults do
  it "should hold multiple development applications" do
    da1 = DevelopmentApplication.new(:description => "A house being built")
    da2 = DevelopmentApplication.new(:description => "A house being knocked down")
    r = PlanningAuthorityResults.new
    r << da1
    r << da2
    r.applications.should == [da1, da2]
  end
  
  it "should have a short name and a regular name" do
    r = PlanningAuthorityResults.new(:name => "Blue Mountains City Council", :short_name => "Blue Mountains")
    r.name.should == "Blue Mountains City Council"
    r.short_name.should == "Blue Mountains"
  end
end