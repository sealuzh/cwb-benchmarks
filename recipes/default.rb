require 'pry'
# Debug with: binding.pry

Cwb.cwb_log
bm = Cwb.new

file '/home/vagrant/script1.rb' do
  Cwb.my_defaults(self)
  action :create
  content <<-EOF
#!/usr/bin/env ruby
puts 'This is Ruby1!'
  EOF
end

file '/home/vagrant/script2.rb' do
  Cwb.my_defaults(self)
  action :create
  content "#{bm.my_content}"
  Cwb.cwb_log
  bm.my_method
end

# Append the Chef ruby to the path for all users.
# Needs to relogin in order to take effect which might be relevant for
# users that already ssh'ed into a machine before this resource is run
# Consider doing this conditionally (i.e., only if no ruby is in the path)
EMBEDDED_BIN = "#{Chef::Config.embedded_dir}/bin"
file '/etc/profile.d/EMBEDDED_BIN.sh' do
  action :create
  owner 'root'
  group 'root'
  mode '0644'
  content "export PATH=$PATH:#{EMBEDDED_BIN}"
end
