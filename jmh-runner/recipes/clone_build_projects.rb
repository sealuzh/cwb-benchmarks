require 'fileutils'
require 'pathname'

projects = node['jmh-runner']['projects']

path = node['jmh-runner']['env']['basedir']

puts "Starting to install Java projects to benchmark into path #{path}"

projects.each_with_index do |project, index|

  # clone and checkout repo
  group = project['project']['github']['group']
  name = project['project']['github']['name']
  url = "https://github.com/%s/%s.git" % [group, name]

  full_name = "%s/%s" % [path,name]
  version = project['project']['version']

  git "jmh_clone_project_#{index}" do
    repository url
    if version
      revision version
    end
    destination full_name
    action :checkout
    notifies :run, "bash[jmh_compile_project_#{index}]", :immediately
  end

  # compile using the appropriate backend
  backend = project['project']['backend']
  case backend
    when 'gradle'
      target = project['project']['gradle']['build_cmd']
      bash "jmh_compile_project_#{index}" do
       timeout 60 * 60  # increase timeout to 60 mins
       cwd full_name
       code "./gradlew #{target}"
       notifies :run, "bash[jmh_fix_permissions_#{index}]", :immediately
       action :nothing
      end
    when 'mvn'
      bash "jmh_compile_project_#{index}" do
       timeout 60 * 60  # increase timeout to 60 mins
       cwd full_name
       code 'mvn -q clean install -DskipTests'
       notifies :run, "bash[jmh_fix_permissions_#{index}]", :immediately
       action :nothing
      end
    else
      raise "Unsupported backend " + backend
  end

  bash "jmh_fix_permissions_#{index}" do
   cwd path
   code "chmod -R 0777 #{full_name}"
   action :nothing
  end


end
