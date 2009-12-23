#!/usr/bin/env ruby

# Simple command line tool for outputting to stdout the result of scraping a particular planning authority
# Mainly useful during development

require 'optparse'
require 'scraper_factory'

OptionParser.new do |opts|
  opts.banner = <<EOF
Usage: scraper-output.rb <short_authority_name> [<date>]
    If date is not given defaults to today
    example:
      scraper-output.rb blue_mountains 2009-12-11
EOF
end.parse!

if ARGV.size > 0
  short_name = ARGV.shift  
else
  puts "Need to supply a short authority name"
  exit
end

if ARGV.size > 0
  date = Date.parse(ARGV.shift)
else
  date = Date.today
end

if ARGV.size > 0
  puts "Too many parameters"
  exit
end

scraper = Scrapers::scraper_factory(short_name)
if scraper
  puts scraper.results_as_xml(date)
else
  puts "Could not find an authority with that short name"
  valid_short_names = Scrapers::scrapers.map{|s| s.planning_authority_short_name_encoded}.sort
  puts "Valid authority names are: #{valid_short_names.join(', ')}"
end
