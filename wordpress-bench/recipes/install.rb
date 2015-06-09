# Install wordpress
node.default['wordpress']['version'] = '4.2.2'
node.default['wordpress']['wp_config_options'] = { 'AUTOMATIC_UPDATER_DISABLED' => true }
node.default['wordpress']['db']['name'] = 'wordpress'
node.default['wordpress']['db']['user'] = 'wordpress'
node.default['wordpress']['db']['pass'] = 'wordpress'
# mod_php5 (used by Wordpress) requires non-threaded MPM such as prefork
# @see apache2/recipes/mod_php5.rb:22
# @see attributes https://github.com/svanzoest-cookbooks/apache2/#prefork-attributes
node.default['apache']['mpm'] = 'prefork'

# Fix for VM restart (@see https://github.com/brint/wordpress-cookbook/issues/55)
directory '/var/run/mysqld' do
  cwb_defaults(self)
  action :create
end
node.set['wordpress']['server_name'] = 'localhost'
include_recipe 'wordpress::default'

# Install_wp_cli
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

# Setup wordpress including data generation plugin
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
    # Install fakerpress plugin via zip because older version doesn't exist anymore at
    # the Wordpress plugin registry: https://wordpress.org/plugins/fakerpress
    # wp.install_plugin!('fakerpress', version: '0.3.1')
    wp.install_plugin!('https://github.com/bordoni/fakerpress/archive/0.3.1.zip')
  end
  action :run
end
