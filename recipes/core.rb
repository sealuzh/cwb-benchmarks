require 'yaml'

# Append the Chef Ruby to the path for all users in order
# to facilite debbuging using interactive shells.
# ATTENTION: This only applies to interactive shells
# => Remote ssh command MUST explicitly set the path!
# NOTE: Users that already ssh'ed into a machine before
# this resource is run is run might require to re-login.
EMBEDDED_BIN = File.join(Chef::Config.embedded_dir, 'bin')
file '/etc/profile.d/EMBEDDED_BIN.sh' do
  action :create
  mode '0644'
  content "export PATH='#{EMBEDDED_BIN}':$PATH"
end

directory Cwb::Util.base_dir(node) do
  cwb_defaults(self)
  action :create
  recursive true
end

redirect_io = node['benchmark']['redirect_io'].to_s == 'true'
template Cwb::Util.base_path_for(node['benchmark']['start_runner'], node) do
  cwb_defaults(self)
  mode 0755
  source 'start_runner.sh.erb'
  variables(embedded_bin: EMBEDDED_BIN,
            benchmark_start: node['benchmark']['start'],
            redirect_io: redirect_io)
end

template Cwb::Util.base_path_for(node['benchmark']['start'], node) do
  cwb_defaults(self)
  mode 0755
  source 'start.sh.erb'
  variables(base_dir: Cwb::Util.base_dir(node))
end

cwb_benchmark_suite 'cleanup suite' do
  action :cleanup
end

cwb_benchmark 'cleanup benchmark' do
  action :cleanup
end

# TODO: consider filtering here (the entire stuff will later be loaded into memory during the benchmark execution!)
file Cwb::Util.config_file(node) do
  cwb_defaults(self)
  action :create
  content node.attributes.to_hash.to_yaml
end 


### Example usage:
sysbench = Cwb::BenchmarkUtil.new('sysbench', node)
cwb_benchmark sysbench.name do
  action :install
end

my_custom_suite = Cwb::BenchmarkUtil.new('my-custom-suite', node)
cwb_benchmark_suite my_custom_suite.name do
  action :install
end


# Might be not needed anyway (consider backwards compatibility => might update existing cookbooks to drop it)
# template "#{node["benchmark"]["dir"]}/#{node["benchmark"]["stop_and_postprocess_runner"]}" do
#   owner node["benchmark"]["owner"]
#   group node["benchmark"]["group"]
#   mode 0755
#   variables(stop_and_postprocess: node["benchmark"]["stop_and_postprocess"],
#             redirect_io: redirect_io)
#   source 'stop_and_postprocess_runner.sh.erb'
# end

# In order to support existing benchmarks, the BenchmarkHelper utility should forward requests
# to the new Cwb::Client utilty.
# Requires the provider_name and provider_instance_id to be set in advance
# Write this into the config
# workbench_server = data_bag_item('benchmark', 'workbench_server')
# template File.join(BenchmarkUtil.base_dir ,'benchmark_helper.rb') do
#   BenchmarkUtil.defaults
#   mode 0755
#   variables(workbench_server:     workbench_server['value'],
#             provider_name:        node['benchmark']['provider_name'],
#             provider_instance_id: node['benchmark']['provider_instance_id'])
#   source 'benchmark_helper.rb.erb'
# end
