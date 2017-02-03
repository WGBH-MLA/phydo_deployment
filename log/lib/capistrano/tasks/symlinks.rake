# cap demo symlinks


set :sudo_symlinks, {
  "/srv/www/aapb/shared/jetty/solr/blacklight-core/data" => "/mnt/aapb-solr-data/data"
}



task :symlinks do
  # default task for symlinks namespace is symlinks:no_sudo
  invoke "symlinks:all"
end

namespace :symlinks do

  desc "Creates all symlinks specified in :symlinks and :sudo_symlinks config variables."
  task :all do
    invoke "symlinks:without_sudo"
    invoke "symlinks:with_sudo"
  end


  desc "Creates symlinks specified in :symlinks config variable."
  task :without_sudo do
    on roles(:app) do
      fetch(:symlinks, []).each do |link, target|
        execute :ln, '-s', link, target
      end
    end
  end

  desc "Creates symlinks specified in :sudo_symlinks config variable, using sudo."
  task :with_sudo do
    on roles(:app) do
      fetch(:sudo_symlinks, {}).each do |link, target|
        execute :sudo, :ln, '-s', target, link
      end
    end
  end
end