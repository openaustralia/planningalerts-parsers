# Monkey Patch the Date class
class Date
  def self.parse_with_non_american_bias(text)
    if text =~ /^(\d{1,2})\/(\d{1,2})\/(\d{4})/
      # Assume this is non-american order
      Date.new($~[3].to_i, $~[2].to_i, $~[1].to_i)
    else
      Date.parse_without_non_american_bias(text)
    end
  end
  
  class << self
    alias :parse_without_non_american_bias :parse
    alias :parse :parse_with_non_american_bias
  end
end

