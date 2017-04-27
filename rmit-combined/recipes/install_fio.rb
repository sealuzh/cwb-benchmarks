# Inspired by:
#  * Install a file from a remote location using bash:
#     http://docs.opscode.com/resource_remote_file.html
#  * Install a program from source:
#     http://stackoverflow.com/questions/8530593/chef-install-and-update-programs-from-source
include_recipe 'apt'
include_recipe 'build-essential'

# Composing the `source_url` here allows to override attributes
file_name = "fio-#{node['fio']['version']}.tar.gz"
source_url = "#{node['fio']['source_repo']}#{file_name}"
target = Chef::Config['file_cache_path']

# Download specific version only if not already present
remote_file "#{target}/#{file_name}" do
  source source_url
  action :create_if_missing
  notifies :run, "bash[install_fio]", :immediately
end

# Build specific version from source
dir_name = "fio-#{node['fio']['version']}"
bash "install_fio" do
 cwd target
 code <<-EOH
  tar -zxf #{file_name}
  (cd #{dir_name} && ./configure && make && sudo make install)
 EOH
 action :nothing
end
