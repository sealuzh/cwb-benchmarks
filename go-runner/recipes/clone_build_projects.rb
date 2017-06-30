require 'fileutils'
require 'pathname'

projects = node['go-runner']['projects']

go_path = node['go-runner']['env']['go']
go_root = node['go-runner']['env']['go-root']
go_binaries = node['go-runner']['env']['go-binaries']
go_own_path = node['go-runner']['env']['go-own-path']

puts "Starting to install Go projects to benchmark into path #{go_own_path}"

projects.each do |project|

  # clone and checkout repo
  group = project['project']['github']['group']
  name = project['project']['github']['name']
  url = "https://github.com/%s/%s.git" % [group, name]

  puts "Installing #{url}"

  project_path = "%s/%s" % [go_own_path, name]
  # assume project is hosted on github
  path_to_group = "%s/src/github.com/%s" % [project_path, group]
  FileUtils.rm_rf(project_path) if File.exist?(project_path)
  bash "create_project_path" do
    cwd go_own_path
    code "mkdir -p #{path_to_group}"
  end

  bash "clone_project" do
    cwd path_to_group
    code "git clone #{url}"
  end

  path_to_project = "%s/%s" % [path_to_group, name]
  version = project['project']['version']
  if version
    bash "checkout_version" do
      cwd path_to_project
      code "git checkout #{version}"
    end
  end

  # fetch dependencies using the appropriate backend
  backend = project['project']['backend']
  case backend
    # case install glide
    when 'glide'
      bash "deps_glide" do
        ENV['GOPATH'] = project_path
        timeout 60 * 60  # increase timeout to 60 mins
        cwd path_to_project
        code <<-EOT
          echo "----------------------------------------------------------------------------"
          echo $GOPATH
          echo $PATH
          glide install
        EOT
      end
    # case install go get
    when 'get'
      bash "deps_goget" do
        ENV['GOPATH'] = project_path
        timeout 60 * 60  # increase timeout to 60 mins
        cwd path_to_project
        code "go get $(go list ./... | grep -v vendor)"
      end
    else
      raise "Unsupported Package Management System: " + backend
  end

  bash "fix_permissions" do
   cwd path
   code "chmod -R 0777 #{project_path}"
  end

end
