### Install your benchmark here by leveraging
# Chef resources: http://docs.chef.io/resources.html
# Community cookbooks: https://supermarket.chef.io/dashboard

## Example:
# Update apt package index (make sure you declare dependencies in metadata.rb)
# include_recipe 'apt'

# package 'YOUR_PACKAGE' do
#   action :install
# end
require 'pry'

# install wordpress
node.default['wordpress']['version'] = '4.2.1'
node.default['wordpress']['db']['name'] = 'wordpress'
node.default['wordpress']['db']['user'] = 'wordpress'
node.default['wordpress']['db']['pass'] = 'wordpress'
include_recipe 'wordpress::default'

# install_wp_cli
directory File.basename(node['wordpress-bench']['wp_cli_bin']) do
  cwb_defaults(self)
  action :create
  recursive true
end

remote_file node['wordpress-bench']['wp_cli_bin'] do
  cwb_defaults(self)
  mode '0744'
  source node['wordpress-bench']['wp_cli_url']
end

# setup wordpress including data generation plugin
ruby_block 'setup_wordpress' do
  block do
    wp = WordpressBench::WpCli.new(node['wordpress']['dir'],
                                 node['wordpress']['install']['user'],
                                 node['wordpress-bench']['wp_cli_bin'])
    wp.install_core!(url: node['wordpress-bench']['url'],
                     title: node['wordpress-bench']['title'],
                     admin_user: node['wordpress-bench']['admin_user'],
                     admin_password: node['wordpress-bench']['admin_password'],
                     admin_email: node['wordpress-bench']['admin_email'])
    wp.update_url!(node['wordpress-bench']['url'])
    wp.install_plugin!('fakerpress', version: '0.3.0')
  end
  action :run
end

# install FakerPress Ruby client dependencies
%w(faraday faraday-cookie_jar nokogiri).each do |gem_name|
  chef_gem gem_name do
    compile_time true if respond_to?(:compile_time)
    options '--no-document'
  end
end

# generate fake data
ruby_block 'generate_fake_data' do
  block do
    data_set = WordpressBench::DemoDataSet.new(node['wordpress']['dir'])
    unless data_set.applied?
      faker = WordpressBench::BatchedFakerPress.new(node['wordpress-bench']['url'],
                                                    node['wordpress-bench']['batch_size'])
      faker.login(node['wordpress-bench']['admin_user'],
                  node['wordpress-bench']['admin_password'])
      api_customer_key = node['wordpress-bench']['500px_customer_key']
      faker.save_api_key(api_customer_key) unless api_customer_key.empty?
      data_set.apply!(faker)
    end
  end
end
