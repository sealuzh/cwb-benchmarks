include_recipe 'apt'
include_recipe 'build-essential'

# Composing the `source_url` here allows to override attributes
file_name = "stress-ng-#{node['stressng']['version']}.tar.gz"
source_url = "#{node['stressng']['source_repo']}#{file_name}"
target = Chef::Config['file_cache_path']

# Download specific version only if not already present
remote_file "#{target}/#{file_name}" do
  source source_url
  action :create_if_missing
  notifies :run, "bash[install_stressng]", :immediately
end

# Build specific version from source
dir_name = "stress-ng-#{node['stressng']['version']}"
bin = File.join(target, dir_name, 'stress-ng')
link_dest = 'usr/local/bin/stress-ng'
bash "install_stressng" do
 cwd target
 code <<-EOH
  tar -zxf #{file_name}
  (cd #{dir_name} && make)
 EOH
 action :nothing
 notifies :create, "link[#{link_dest}]", :immediately
end

# Symlink into PATH
link link_dest do
  to bin
  action :nothing
end
