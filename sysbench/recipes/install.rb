# Update package index (i.e., apt-get update on Debian)
include_recipe 'apt'

package 'sysbench' do
  action :install
end
