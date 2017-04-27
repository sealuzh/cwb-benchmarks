require 'open3'

module Hostname
  module Helpers
    def guess_public_ip
      ohai_cloud_ip || query_public_ip || fallback
    end

    def ohai_cloud_ip
      node['cloud']['public_ipv4'] rescue nil
    end

    def query_public_ip
      run_cmd(public_ip_query)
    end

    def public_ip_query
      node['rmit-combined']['public_ip_query']
    end

    def run_cmd
      stdout, stderr, status = Open3.capture3(cmd)
      raise "[Hostname::Helpers] #{stderr}" unless status.success?
      stdout
    end

    def fallback
      'localhost'
    end
  end
end
