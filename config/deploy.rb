# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'AAPB'
set :repo_url, 'https://github.com/WGBH/AAPB2.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/aapb'

# If the branch is not set with an env var, then ask for it.
if ENV['AAPB_BRANCH']
  set :branch, ENV['AAPB_BRANCH']
else
  ask :branch, 'master'
end

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/ci.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'tmp/downloads', 'jetty')

set :rails_env, :production

namespace :deploy do
  before :starting, "confirm_hosts"
  before :starting, "config:all"

  after :updated, :ensure_jetty_is_installed do
    invoke 'jetty:install'
  end
end
