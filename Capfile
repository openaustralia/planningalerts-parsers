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
elsif stage == "test"
  set :deploy_to, "/srv/www/test.#{application}"
  #set :branch, "test"
end

namespace :deploy do
  task :restart, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"

    # Don't auto-reload authorities as they're managed in the web admin interface now
    # run "cd #{deploy_to}/../app/current && bundle exec rake planningalerts:authorities:load RAILS_ENV=production"
  end
end
