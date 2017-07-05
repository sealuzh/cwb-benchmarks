require 'fileutils'
require 'pathname'

projects = node['go-runner']['projects']

go_path = node['go-runner']['env']['go']
go_root = node['go-runner']['env']['go-root']
go_binaries = node['go-runner']['env']['go-binaries']
go_own_path = node['go-runner']['env']['go-own-path']

puts "Starting to install Go projects to benchmark into path #{go_own_path}"

projects.each_with_index do |project, index|

  # clone and checkout repo
  group = project['project']['github']['group']
  name = project['project']['github']['name']

  puts "Clone and install %s/%s" % [group, name]

  url = "https://github.com/%s/%s.git" % [group, name]

  puts "Installing #{url}"

  project_path = "%s/%s" % [go_own_path, name]
  # assume project is hosted on github
  path_to_group = "%s/src/github.com/%s" % [project_path, group]
  FileUtils.rm_rf(project_path) if File.exist?(project_path)
  bash "go_create_project_path_#{index}" do
    cwd go_own_path
    code <<-EOT
      mkdir -p #{path_to_group}
    EOT
    notifies :checkout, "git[go_clone_project_#{index}]", :immediately
  end

  path_to_project = "%s/%s" % [path_to_group, name]
  version = project['project']['version']

  git "go_clone_project_#{index}" do
    repository url
    if version
      revision version
    end
    destination path_to_project
    action :nothing
    notifies :run, "bash[go_deps_#{index}]", :immediately
  end

  # fetch dependencies using the appropriate backend
  backend = project['project']['backend']
  case backend
    # case install glide
    when 'glide'
      bash "go_deps_#{index}" do
        timeout 60 * 60  # increase timeout to 60 mins
        cwd path_to_project
        environment "GOPATH" => project_path
        code <<-EOT
          glide install
        EOT
       notifies :run, "bash[go_fix_permissions_#{index}]", :immediately
       action :nothing
      end
    # case install go get
    when 'get'
      bash "go_deps_#{index}" do
        timeout 60 * 60  # increase timeout to 60 mins
        cwd path_to_project
        environment "GOPATH" => project_path
        code <<-EOT
          go get $(go list ./... | grep -v vendor)
        EOT
       notifies :run, "bash[go_fix_permissions_#{index}]", :immediately
       action :nothing
      end
    else
      raise "Unsupported Package Management System: " + backend
  end

  bash "go_fix_permissions_#{index}" do
   code "chmod -R 0777 #{project_path}"
   action :nothing
  end

end
