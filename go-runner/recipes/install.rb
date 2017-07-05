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
go_path = node['go-runner']['env']['go']
goptc_group_folder = "%s/%s" % [go_path, "src/bitbucket.org/sealuzh"]
ssh_dir = node['go-runner']['env']['ssh-dir']

bash "go_create_paths" do
    cwd node['go-runner']['env']['basedir']
    code <<-EOT
        mkdir -p #{go_install_dir}
        mkdir -p #{goptc_group_folder}
        mkdir -p #{go_path}/bin
        mkdir -p #{ssh_dir}
        mkdir -p #{node['go-runner']['env']['go-own-path']}
    EOT
    notifies :create_if_missing, "remote_file[#{go_file}]", :immediately
end

remote_file go_file do
    source go_file
    path ("%s/%s" % [go_install_dir, go_file_name])
    action :nothing
    notifies :run, "bash[go_install]", :immediately
end

# set environment
ENV['GOROOT'] = node['go-runner']['env']['go-root']
ENV['GOPATH'] = node['go-runner']['env']['go']
ENV['PATH'] = "#{ENV['PATH']}:#{node['go-runner']['env']['go-binaries']}:#{node['go-runner']['env']['go']}/bin"

bash "go_install" do
    cwd go_install_dir
    code <<-EOT
        echo $PATH
        tar -C /usr/local -xzf #{go_file_name}
    EOT
    action :nothing
    notifies :run, "bash[go_install_glide]", :immediately
end

bash "go_install_glide" do
    code <<-EOT
        curl https://glide.sh/get | sh
    EOT
    action :nothing
    notifies :create_if_missing, "file[go_create_ssh_wrapper]", :immediately
end

ssh_wrapper = ssh_dir + "/git_wrapper.sh"
ssh_file = ssh_dir + "/key"
file "go_create_ssh_wrapper" do
    path ssh_wrapper
    owner "ubuntu"
    group "ubuntu"
    mode "0755"
    content "#!/bin/sh\nssh-keyscan bitbucket.org >>~/.ssh/known_hosts\nexec /usr/bin/ssh -i #{ssh_file} -o StrictHostKeyChecking=no \"$@\""
    action :create_if_missing
    notifies :create_if_missing, "cookbook_file[go_create_ssh_key]", :immediately
end

#transfer key
cookbook_file "go_create_ssh_key" do
    path ssh_file
    source 'keys/goptc_cwb'
    owner 'ubuntu'
    group 'ubuntu'
    mode '0600'
    action :create_if_missing
    notifies :checkout, "git[go_get_goptc]", :immediately
end

goptc_folder = goptc_group_folder + "/goptc"
git "go_get_goptc" do
    destination goptc_folder
    repository node['go-runner']['env']['goptc']
    reference node['go-runner']['env']['goptc_branch']
    action :checkout
    ssh_wrapper ssh_wrapper
    notifies :run, "bash[go_install_goptc]", :immediately
end

bash "go_install_goptc" do
    cwd goptc_folder
    code <<-EOT
        echo $PATH
        go get ./...
        go install
    EOT
    action :nothing
    notifies :run, "ruby_block[go_clone_install_projects]", :immediately
end

ruby_block "go_clone_install_projects" do
    block do
        run_context.include_recipe 'go-runner::clone_build_projects'
    end
    action :nothing
end
