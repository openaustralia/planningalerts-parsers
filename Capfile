load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

set :application, "planningalerts.org.au/parsers"
set :repository,  "git://git.openaustralia.org/planningalerts-parsers.git"

set :scm, :git

set :stage, "test" unless exists? :stage

set :use_sudo, false

if stage == "production"
  set :deploy_to, "/srv/www/www.#{application}"
elsif stage == "test"
  set :deploy_to, "/srv/www/test.#{application}"
  #set :branch, "test"
end

set :user, "deploy"

role :web, "openaustralia.org"

namespace :deploy do
  desc "Restart doesn't do anything"
  task :restart do ; end
end
