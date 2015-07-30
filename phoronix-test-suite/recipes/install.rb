include_recipe 'apt'

package 'phoronix-test-suite' do
  action :install
end

# Provide user config for batch install
# NOTE: ENV['HOME'] and node['current_user'] points to root instead to the right user home dir
# HACK: This is intended for internal use in the `cwb` cookbook
#       A cleaner solution could offer a utility method via the cwb cookbook 
user = node['benchmark']['ssh_username'] || node['benchmark']['owner']
home = Dir.home(user)
phoronix_path = "#{home}/.phoronix-test-suite"
directory phoronix_path do
  cwb_defaults(self)
  mode '0755'
  action :create
end
cookbook_file File.join(phoronix_path, 'user-config.xml') do
  cwb_defaults(self)
  source 'user-config.xml'
end

node['phoronix-test-suite']['tests'].each do |name, value|
  execute "install-test-#{name}" do
    user user
    group user
    command "phoronix-test-suite batch-install #{name}"
    environment({ 'HOME' => home })
    action :run
  end
end
