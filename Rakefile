require 'rspec/core/rake_task'

task :default => :spec

# Change the standard spec task so that it only runs the tests in spec/unit by default
RSpec::Core::RakeTask.new do |t|
  t.pattern = FileList['spec/unit/*.rb']
end  

desc "Run regression tests (very slow and requires network access)"
RSpec::Core::RakeTask.new('regression') do |t|
  t.pattern = FileList['spec/regression/*.rb']
end
