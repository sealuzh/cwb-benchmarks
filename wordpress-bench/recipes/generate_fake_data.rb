node.override['apt']['compile_time_update'] = true
# Workaround to run `apt-get update` first on compile time before `build-essential`
# See: https://github.com/chef-cookbooks/build-essential/issues/41#issuecomment-84178604
first_run_file = "/tmp/apt-get-update-stamp"
if node['apt']['compile_time_update'] && !::File.exist?(first_run_file)
  e = bash 'apt-get-update at compile time' do
    code <<-EOH
      apt-get update
      touch #{first_run_file}
    EOH
    ignore_failure true
    only_if { apt_installed? }
    action :nothing
  end
  e.run_action(:run)
end
include_recipe 'apt::default'

# faraday-cookie_jar and nokogiri must compile native extensions
node.override['build-essential']['compile_time'] = true
include_recipe 'build-essential::default'

# node.default['libxml2']['compile_time'] = true
# include_recipe 'libxml2::default'

# When using chef_gem to install nokogiri, zlib1g-dev package is needed
# See: https://github.com/SearchSpring/chef_nokogiri/issues/1
# TODO: Check whether this also works on other systems than Ubuntu
package 'zlib1g-dev' do
  action :nothing
end.run_action(:install)

# Install FakerPress Ruby client dependencies
gem_dependencies = {
  'faraday' => '0.9.1',
  'faraday-cookie_jar' => '0.0.6',
  'nokogiri' => '1.6.8.1',
}
gem_dependencies.each do |gem_name, gem_version|
  chef_gem gem_name do
    compile_time true if respond_to?(:compile_time)
    options '--no-document'
    version gem_version unless gem_version.nil?
  end
end

# Reload and restart apache config here to make WordPress available
# NOTICE: the apache2 recipe delays the reload and restart to the end of the Chef run
#    see: https://github.com/sous-chefs/apache2/blob/master/recipes/default.rb#L155
service 'apache2' do
  action [:reload, :restart]
end

# Generate fake data
site = node['wordpress']['site']
ruby_block 'generate_fake_data' do
  block do
    data_set = WordpressBench::DemoDataSet.new(node['wordpress']['dir'])
    unless data_set.applied?
      sleep(30) # Make sure the server is ready
      faker = WordpressBench::BatchedFakerPress.new(site['url'],
                                                    node['wordpress-bench']['batch_size'])
      faker.login(site['admin_user'],
                  site['admin_password'])
      api_customer_key = node['wordpress-bench']['500px_customer_key']
      sleep(5)
      faker.save_api_key(api_customer_key) unless api_customer_key.empty?
      Chef::Log.info('Start generating fake Wordpress data!')
      data_set.apply!(faker)
      Chef::Log.info('Finished generating fake Wordpress data!')
    end
  end
  retries 2
  retry_delay 30 # seconds
end
