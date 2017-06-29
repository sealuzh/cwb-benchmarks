require 'fileutils'
require 'pathname'

projects = node['go-runner']['projects']

# this is a bit of a hack, but the go-runner dir is not yet available
# at this point in the Chef run - so clone to the base dir for now
path = node['go-runner']['env']['basedir']

puts "Starting to install Go projects to benchmark into path #{path}"

go_path = default['go-runner']['env']['go']
go_root = default['go-runner']['env']['go-root']
go_binaries = default['go-runner']['env']['go-binaries']
go_own_path = default['go-runner']['env']['go-own-path']

projects.each do |project|

  # clone and checkout repo
  group = project['project']['github']['group']
  name = project['project']['github']['name']
  url = "https://github.com/%s/%s.git" % [group, name]

  puts "Installing #{url}"

  project_path = "%s%s" % [go_own_path, name]
  # assume project is hosted on github
  path_to_group = "%s/src/github.com/%s/" % [project_path, name]
  FileUtils.rm_rf(project_path) if File.exist?(project_path)
  bash "create_project_path" do
    cwd go_own_path
    code "mkdir -p #{path_to_group}"
    EOT
  end

  bash "clone_project" do
    cwd path_to_group
    code "git clone #{url}"
  end

  path_to_project = "%s%s" % [path_to_group, name]
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
      ENV['GOROOT'] = go_root
      ENV['GOPATH'] = project_path
      ENV['PATH'] += (":%s" % [go_binaries])
      timeout 60 * 60  # increase timeout to 60 mins
      cwd path_to_project
      code "glide install"
    end
  end
  # case install go get
  when 'get'
    bash "deps_goget" do
      ENV['GOROOT'] = go_root
      ENV['GOPATH'] = project_path
      ENV['PATH'] += (":%s" % [go_binaries])
      timeout 60 * 60  # increase timeout to 60 mins
      cwd path_to_project
      code "go get $(go list ./... | grep -v vendor)"
    end
  end
  else 
    raise "Unsupported Package Management System: " + backend
  end

  bash "fix_permissions" do
   cwd path
   code "chmod -R 0777 #{project_path}"
  end

end
