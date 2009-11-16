class SimpleStruct
  def initialize(options)
    options.each do |attribute, value|
      instance_variable_set("@" + attribute.to_s, value)
    end
  end
end

def SimpleStruct(*attributes)
  c = Class.new(SimpleStruct)
  c.send(:attr_accessor, *attributes)
  c
end
