module WordpressBench
  module Helpers
    def vagrant?
      node['domain'] == 'vagrantup.com'
    end

    def default_ip
      vagrant? ? node['ipaddress'] : public_ip
    end

    def public_ip
      Mixlib::ShellOut.new(node['wordpress-bench']['public_ip_query']).run_command.stdout
    end
  end
end