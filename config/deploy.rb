# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'phydo'
set :repo_url, 'https://github.com/WGBH/phydo.git'
set :deploy_to, '/var/www/phydo'

# If the branch is not set with an env var, then ask for it.
if ENV['PHYDO_BRANCH']
  set :branch, ENV['PHYDO_BRANCH']
else
  ask :branch, 'wgbh-master'
end

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'tmp/downloads')

set :rails_env, :production

namespace :deploy do
  before :starting, "confirm_hosts"
  before :starting, "config:all"
end
