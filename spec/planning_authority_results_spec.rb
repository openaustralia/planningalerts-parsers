require 'spec'

require 'planning_authority_results'
require 'development_application'

describe PlanningAuthorityResults do
  it "should hold multiple development applications" do
    da1 = DevelopmentApplication.new(:description => "A house being built")
    da2 = DevelopmentApplication.new(:description => "A house being knocked down")
    r = PlanningAuthorityResults.new
    r << da1
    r << da2
    r.applications.should == [da1, da2]
  end
end