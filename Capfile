load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

require 'bundler/capistrano'
require 'rvm/capistrano'

set :rvm_ruby_string, :local

set :application, "scrapers.planningalerts.org.au"
set :repository,  "git://github.com/openaustralia/planningalerts-parsers.git"

role :web, "kedumba.openaustraliafoundation.org.au"

set :use_sudo, false
set :user, "deploy"
set :scm, :git
set :stage, "test" unless exists? :stage

if stage == "production"
  set :deploy_to, "/srv/www/#{application}"
  set :branch, "master" unless exists? :branch
elsif stage == "test"
  set :deploy_to, "/srv/www/test.#{application}"
  set :branch, "test" unless exists? :branch
end

namespace :deploy do
  task :restart, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
