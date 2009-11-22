$:.unshift "#{File.dirname(__FILE__)}/scrapers"

require 'parse_blue_mountains'
require 'parse_brisbane'
require 'parse_gold_coast'

def parser_factory(name)
  parsers = [BlueMountainsParser.new, BrisbaneParser.new, GoldCoastParser.new]
  parsers.find{|p| p.planning_authority_short_name.downcase.gsub(' ', '_') == name}
end
