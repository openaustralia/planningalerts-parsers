class PlanningAuthorityResults
  attr_reader :applications
  
  def initialize
    @applications = []
  end
  
  def <<(da)
    @applications << da
  end
end