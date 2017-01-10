node.default['apt']['compile_time_update'] = true
include_recipe 'apt::default'

# faraday-cookie_jar and nokogiri must compile native extensions
node.default['build-essential']['compile_time'] = true
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

# Generate fake data
ruby_block 'generate_fake_data' do
  block do
    data_set = WordpressBench::DemoDataSet.new(node['wordpress']['dir'])
    unless data_set.applied?
      sleep(30) # Make sure the server is ready
      faker = WordpressBench::BatchedFakerPress.new(node['wordpress-bench']['url'],
                                                    node['wordpress-bench']['batch_size'])
      faker.login(node['wordpress-bench']['admin_user'],
                  node['wordpress-bench']['admin_password'])
      api_customer_key = node['wordpress-bench']['500px_customer_key']
      sleep(4)
      faker.save_api_key(api_customer_key) unless api_customer_key.empty?
      Chef::Log.warn('Start generating fake Wordpress data')
      data_set.apply!(faker)
      Chef::Log.warn('Finished generating fake Wordpress data')
    end
  end
end
