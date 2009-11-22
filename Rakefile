require 'rake'
require 'spec/rake/spectask'

task :default => :spec

# Change the standard spec task so that it only runs the tests in spec/unit by default
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/unit/*.rb']
end  

desc "Run regression tests (very slow and requires network access)"
Spec::Rake::SpecTask.new('regression') do |t|
  t.spec_files = FileList['spec/regression/*.rb']
end