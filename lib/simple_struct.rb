class SimpleStruct
  def initialize(options)
    options.each do |attribute, value|
      if attributes.include?(attribute)
        instance_variable_set("@" + attribute.to_s, value)
      else
        raise "Unexpected attribute #{attribute} used"
      end
    end
  end
end

def SimpleStruct(*attributes)
  c = Class.new(SimpleStruct)
  c.send(:attr_accessor, *attributes)
  c.send(:define_method, :attributes) { attributes }
  c
end
