include_recipe 'apt::default'
package 'default-jre' do
  action :install
end
package 'unzip'

ark 'perfmon' do
  url node['perfmon']['source_url']
  version node['perfmon']['version']
  checksum node['perfmon']['checksum']
  # See: https://github.com/chef-cookbooks/ark/issues/72#issuecomment-146268255
  strip_components 0
  action :install
end
