class SimpleStruct
  def self.add_attributes(*attributes)
    attr_accessor *attributes
    @attributes = [] if @attributes.nil?
    @attributes += attributes
  end
  
  # Attributes are inherited from the parents
  def self.attributes
    if superclass.instance_variable_get('@attributes')
      superclass.instance_variable_get('@attributes') + @attributes
    else
      @attributes
    end
  end
  
  def initialize(options = {})
    attributes_set(options)
  end
  
  # Throws an exception if attribute is not known. Otherwise does nothing.
  def check_attribute!(attribute)
    raise "Unexpected attribute #{attribute} used" unless self.class.attributes && self.class.attributes.include?(attribute)
  end
  
  def attribute_set(attribute, value)
    check_attribute!(attribute)
    send(attribute.to_s + "=", value)
  end
  
  # Returns the value of an attribute
  def attribute_get(attribute)
    check_attribute!(attribute)
    send(attribute.to_s)
  end
  
  def attributes_set(options)
    options.each do |attribute, value|
      attribute_set(attribute, value)
    end
  end
  
  # Returns a hash of attribute names and values
  def attributes_get
    h = {}
    self.class.attributes.each do |a|
      h[a] = attribute_get(a)
    end
    h
  end
  
  def==(other)
    return false unless other.kind_of?(SimpleStruct)
    attributes_get == other.attributes_get
  end
end
