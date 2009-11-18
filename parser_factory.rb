require 'parse_blue_mountains'
require 'parse_brisbane'

def parser_factory(name)
  parsers = [BlueMountainsParser.new, BrisbaneParser.new]
  parsers.find{|p| p.planning_authority_short_name.downcase.gsub(' ', '_') == name}
end
