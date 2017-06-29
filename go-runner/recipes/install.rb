### Install your benchmark here by leveraging
# Chef resources: http://docs.chef.io/resources.html
# Community cookbooks: https://supermarket.chef.io/dashboard

## Example:
# Update apt package index (make sure you declare dependencies in metadata.rb)
include_recipe 'apt'
package 'git'

go_install_dir = node['go-runner']['env']['go-install']
go_file_name = node['go-runner']['env']['go-file']
go_file = "https://storage.googleapis.com/golang/" + go_file_name

goptc_group_folder = "%s%s" % [node['go-runner']['env']['go'], "src/bitbucket.org/sealuzh/"]
bash "create_paths" do
    cwd node['go-runner']['env']['basedir']
    code <<-EOT
        mkdir -p #{go_install_dir}
        mkdir -p #{goptc_group_folder}
        mkdir -p #{node['go-runner']['env']['go-own-path']}
    EOT
    notifies :create_if_missing, "remote_file[#{go_file}]", :immediately
end

remote_file go_file do
    source go_file
    path go_install_dir + go_file_name
    action :nothing
    notifies :run, "bash[install_go]", :immediately
end

bash "install_go" do
    cwd go_install_dir
    environment 'GOROOT' => node['go-runner']['env']['go-root']
    environment 'GOPATH' => node['go-runner']['env']['go']
    environment 'PATH' => "#{ENV['PATH']}:#{node['go-runner']['env']['go']}"
    code <<-EOT
        tar -C /usr/local -xzf #{go_file_name}
    EOT
    action :nothing
    notifies :run, "bash[install_glide]", :immediately
end

#transfer key
ssh_file = go_file_name = node['go-runner']['env']['basedir'] + "ssh/key"

bash "install_glide" do
    environment 'GOROOT' => node['go-runner']['env']['go-root']
    environment 'GOPATH' => node['go-runner']['env']['go']
    environment 'PATH' => "#{ENV['PATH']}:#{node['go-runner']['env']['go']}"
    code <<-EOT
        curl https://glide.sh/get | sh
    EOT
    action :nothing
    notifies :create_if_missing, "cookbook_file[#{ssh_file}]", :immediately
end

cookbook_file ssh_file do
  source '../keys/goptc_cwb'
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
  action :nothing
  notifies :checkout, "git[get_goptc]", :immediately
end

goptc_folder = goptc_group_folder + "goptc"
git "get_goptc" do
    destination goptc_folder
    repository "git@bitbucket.org:sealuzh/goptc.git"
    reference "master"
    action :nothing
    ssh_wrapper "ssh -i #{ssh_file}"
    notifies :run, "bash[install_goptc]", :immediately
end

bash "install_goptc" do
    environment 'GOROOT' => node['go-runner']['env']['go-root']
    environment 'GOPATH' => node['go-runner']['env']['go']
    environment 'PATH' => "#{ENV['PATH']}:#{node['go-runner']['env']['go']}"
    cwd goptc_folder
    code <<-EOT
        go get ./...
        go install
    EOT
    action :nothing
end

# include_recipe 'go-runner::clone_build_projects'
