namespace :deploy do

  desc 'Asks for a confirmation of host confiration'
  task :confirm_hosts do

    unless Capistrano::ConfirmHosts.skip?
      @confirm_host_msgs = roles(:all).map{ |role| "#{role.hostname} as :#{role.properties.roles.to_a.sort.join(', :')}" }

      puts <<-EOS

  Please confirm the following host/role configuration:

    #{@confirm_host_msgs.join("\n    ")}

EOS

      set(:confirm_hosts_answer, ask('"Yes" if you want to deploy to the hosts listed above', 'default is "No"'))
      unless fetch(:confirm_hosts_answer).strip.downcase == 'yes'
        raise Capistrano::ConfirmHosts::NotAccepted, "Host configuration not accepted"
      end
    end

  end

end



module Capistrano
  module ConfirmHosts
    def self.skip?
      val = ENV['SKIP_CONFIRM_HOSTS'].to_s.strip.downcase
      val == 'true' || val=='1'
    end

    class NotAccepted < StandardError; end
  end
end