require 'chef/recipe'
require 'chef/resource'

module Cwb
  module ResourceUtil
    # Defines cwb-specifc default for common resource attributes (i.e., permissions)
    # Method calls that are only available in a resource context
    # must be executed in their context. Therefore, this method
    # takes the resource context, defines a block, and executes
    # that block in the given context.
    def cwb_defaults(context)
      lambda do |con|
        con.owner con.node['benchmark']['ssh_username'] || con.node['benchmark']['owner']
        con.group con.node['benchmark']['ssh_username'] || con.node['benchmark']['group']
        cwb_send_if_respond_to(con, :backup, false)
      end.call(context)
    end

    ### private

    def cwb_send_if_respond_to(context, method, *args)
      if context.respond_to?(method)
        context.send(method, *args)
      end
    end
  end
end

# Make the Cwb module available within all resources
Chef::Resource.send(:include, Cwb::ResourceUtil)
