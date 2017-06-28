require 'fileutils'
require 'pathname'

projects = node['jmh-runner']['projects']

# this is a bit of a hack, but the jmh-runner dir is not yet available
# at this point in the Chef run - so clone to the base dir for now
path = node['jmh-runner']['env']['basedir']

puts "Starting to install Java projects to benchmark into path #{path}"

projects.each_with_index do |project, index|

  # clone and checkout repo
  group = project['project']['github']['group']
  name = project['project']['github']['name']
  url = "https://github.com/%s/%s.git" % [group, name]

  full_name = "%s/%s" % [path,name]
  version = project['project']['version']

  bash "clone_project_#{index}" do
   cwd path
   if not Dir.exists? full_name
     code "git clone #{url}"
     if version
       notifies :run, "bash[checkout_version_#{index}]", :immediately
     else
       notifies :run, "bash[compile_project_#{index}]", :immediately
     end
   else
      notifies :run, "fix_permissions_#{index}", :immediately
   end
  end

  bash "checkout_version_#{index}" do
    cwd full_name
    code "git checkout #{version}"
    notifies :run, "bash[compile_project_#{index}]", :immediately
  end

  # compile using the appropriate backend
  backend = project['project']['backend']
  case backend
    when 'gradle'
      target = project['project']['gradle']['build_cmd']
      bash "compile_project_#{index}" do
       timeout 60 * 60  # increase timeout to 60 mins
       cwd full_name
       code "./gradlew #{target}"
       notifies :run, "bash[fix_permissions_#{index}]", :immediately
      end
    when 'mvn'
      bash "compile_project_#{index}" do
       timeout 60 * 60  # increase timeout to 60 mins
       cwd full_name
       code 'mvn clean install -DskipTests'
       notifies :run, "bash[fix_permissions_#{index}]", :immediately
      end
    else
      raise "Unsupported backend " + backend
  end

  bash "fix_permissions_#{index}" do
   cwd path
   code "chmod -R 0777 #{full_name}"
  end


end
