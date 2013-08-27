require 'bundler'
require 'rspec/core/rake_task'

Bundler.require

task :default => :spec

RSpec::Core::RakeTask.new do |t|
  t.pattern = FileList['spec/**/*_spec.rb']
end

desc 'Outputs the result of scraping a particular planning authority to stdout, useful during development'
task :output, :short_authority_name, :date do |t, args|
  require './scraper_factory'

  valid_authority_names_message = "Valid authority names are: " + Scrapers::scrapers.map{|s| s.planning_authority_short_name_encoded}.sort.join(', ')

  raise "You need to supply a short authority name\n#{valid_authority_names_message}" unless args.short_authority_name

  date = (args.date ? Date.parse(args.date) : Date.today)

  scraper = Scrapers::scraper_factory(args.short_authority_name)
  if scraper
    puts scraper.results_as_xml(date)
  else
    puts "Could not find an authority with that short name"
    puts valid_authority_names_message
  end
end
