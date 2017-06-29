### Install your benchmark here by leveraging
# Chef resources: http://docs.chef.io/resources.html
# Community cookbooks: https://supermarket.chef.io/dashboard

## Example:
# Update apt package index (make sure you declare dependencies in metadata.rb)
include_recipe 'apt'
package 'git'
package 'cookbook_file'

go_install_dir = default['go-runner']['env']['go-install']
go_file_name = node['go-runner']['env']['go-binaries']
go_file = "https://storage.googleapis.com/golang/" + go_file_name

goptc_group_folder = "%s%s" % [default['go-runner']['env']['go'], "src/bitbucket.org/sealuzh/"]
bash "create_paths" do 
    cwd node['go-runner']['env']['basedir']
    cmd <<-EOT
        mkdir #{go_install_dir}
        mkdir -p #{goptc_group_folder}
        mkdir #{default['go-runner']['env']['go-own-path']}
    EOT
end

remote_file go_file do
    source go_file
    action :create_if_missing
    path go_install_dir + go_file_name
    notifies :run, "bash[install_go]", :immediately
end

bash "install_go" do
    cwd go_install_dir
    cmd <<-EOT
        tar -C /usr/local -xzf #{go_file_name}
    EOT
end

bash "install_glide" do
    cmd <<-EOT
        curl https://glide.sh/get | sh
    EOT
end
 
#transfer key
ssh_file = go_file_name = node['go-runner']['env']['basedir'] + "ssh/key"
cookbook_file ssh_file do
  source '../files/keys/goptc_cwb'
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
  action :create
end

goptc_folder = goptc_group_folder + "goptc"
git "get_goptc" do
    destination goptc_folder
    repository "git@bitbucket.org:sealuzh/goptc.git"
    reference "master"
    action :sync
    ssh_wrapper "ssh -i #{ssh_file}"
end

bash "install_goptc" do
    cwd goptc_folder
    ENV['GOROOT'] = default['go-runner']['env']['go-root']
    ENV['GOPATH'] = default['go-runner']['env']['go']
    ENV['PATH'] += default['go-runner']['env']['go']
    cmd <<-EOT
        go get ./...
        go install
    EOT
end

include_recipe 'go-runner::clone_build_projects'
