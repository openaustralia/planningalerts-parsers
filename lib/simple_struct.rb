class SimpleStruct
  def initialize(options)
    attributes_set(options)
  end
  
  def attribute_set(attribute, value)
    if attributes.include?(attribute)
      instance_variable_set("@" + attribute.to_s, value)
    else
      raise "Unexpected attribute #{attribute} used"
    end
  end
  
  # Returns the value of an attribute
  def attribute_get(attribute)
    if attributes.include?(attribute)
      instance_variable_get("@" + attribute.to_s)
    else
      raise "Unexpected attribute #{attribute} used"
    end     
  end
  
  def attributes_set(options)
    options.each do |attribute, value|
      attribute_set(attribute, value)
    end
  end
  
  # Returns a hash of attribute names and values
  def attributes_get
    h = {}
    attributes.each do |a|
      h[a] = attribute_get(a)
    end
    h
  end
  
  def==(other)
    return false unless other.kind_of?(SimpleStruct)
    attributes_get == other.attributes_get
  end
end

def SimpleStruct(*attributes)
  c = Class.new(SimpleStruct)
  c.send(:attr_accessor, *attributes)
  c.send(:define_method, :attributes) { attributes }
  c
end
