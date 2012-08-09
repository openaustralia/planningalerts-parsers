require 'bundler'
require 'rspec/core/rake_task'

Bundler.require

task :default => :spec

RSpec::Core::RakeTask.new do |t|
  t.pattern = FileList['spec/unit/*.rb']
end

desc 'Outputs the result of scraping a particular planning authority to stdout, useful during development'
task :output, :short_authority_name, :date do |t, args|
  raise 'You need to supply a short authority name' unless args.short_authority_name

  require './scraper_factory'

  date = (args.date ? Date.parse(args.date) : Date.today)

  scraper = Scrapers::scraper_factory(args.short_authority_name)
  if scraper
    puts scraper.results_as_xml(date)
  else
    puts "Could not find an authority with that short name"
    valid_short_names = Scrapers::scrapers.map{|s| s.planning_authority_short_name_encoded}.sort
    puts "Valid authority names are: #{valid_short_names.join(', ')}"
  end
end
