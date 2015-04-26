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

def logging_enabled?
  if node['benchmark']['redirect_io'].nil?
    node['benchmark']['logging_enabled']
  else
    node['benchmark']['redirect_io']
  end
end

template Cwb::Util.base_path_for(node['benchmark']['start_runner'], node) do
  cwb_defaults(self)
  mode 0755
  source 'start_runner.sh.erb'
  variables(embedded_bin: EMBEDDED_BIN,
            benchmark_start: node['benchmark']['start'],
            logging_enabled: logging_enabled?)
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

# TODO: consider filtering here because the entire node hash
# will later be loaded into memory during the benchmark execution
file Cwb::Util.config_file(node) do
  cwb_defaults(self)
  # Gets notified from cwb_benchmark (or benchmark_helper for legacy benchmarks) in a delayed manner
  action :nothing
  content lazy { node.attributes.to_hash.to_yaml }
end 

# In order to support existing benchmarks, the BenchmarkHelper utility forwards requests
# to the new Cwb::Client utilty.
cookbook_file File.join(Cwb::Util.base_path_for('benchmark_helper.rb', node)) do
  cwb_defaults(self)
  mode 0755
  source 'benchmark_helper.rb'
  notifies :create, "file[#{Cwb::Util.config_file(node)}]", :delayed
end
