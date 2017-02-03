require 'pry'

namespace :deploy do

  task :ensure_shared_config_dir do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
    end
  end

  namespace :config do
    task :all do
      invoke "deploy:config:database"
      invoke "deploy:config:secrets"
    end

    task :database => [:ensure_shared_config_dir] do
      on roles(:app) do
        upload! './config/database.yml', "#{shared_path}/config/database.yml"
      end
    end

    task :secrets => [:ensure_shared_config_dir] do
      on roles(:app) do
        upload! './config/secrets.yml', "#{shared_path}/config/secrets.yml"
      end
    end
  end
end
