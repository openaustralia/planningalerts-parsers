require 'rake'
require 'spec/rake/spectask'

task :default => :spec

Spec::Rake::SpecTask.new

desc "Run regression tests (very slow and requires network access)"
Spec::Rake::SpecTask.new('regression') do |t|
  t.spec_files = FileList['regression/*.rb']
end