require 'development_application'

class PlanningAuthorityResults
  attr_reader :applications, :name, :short_name
  
  def initialize(options = {})
    @name = options.delete(:name)
    @short_name = options.delete(:short_name)
    raise "Unexpected keys #{options.keys.join(', ')} used" unless options.empty?
    @applications = []
  end
  
  def <<(da)
    @applications << da
  end
end