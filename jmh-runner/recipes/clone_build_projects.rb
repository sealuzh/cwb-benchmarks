require 'fileutils'
require 'pathname'

projects = node['jmh-runner']['projects']

# this is a bit of a hack, but the jmh-runner dir is not yet available
# at this point in the Chef run - so clone to the base dir for now
path = node['jmh-runner']['env']['basedir']

puts "Starting to install Java projects to benchmark into path #{path}"

projects.each do |project|

  # clone and checkout repo
  group = project['project']['github']['group']
  name = project['project']['github']['name']
  url = "https://github.com/%s/%s.git" % [group, name]

  puts "Installing #{url}"

  full_name = "%s/%s" % [path,name]
  FileUtils.rm_rf(full_name) if File.exist?(full_name)
  bash "clone_project" do
   cwd path
   code "git clone #{url}"
  end

  version = project['project']['version']
  if version
    bash "checkout_version" do
      cwd full_name
      code "git checkout #{version}"
    end
  end

  # compile using the appropriate backend
  backend = project['project']['backend']
  case backend
    when 'gradle'
      target = project['project']['gradle']['build_cmd']
      bash "compile_project" do
       timeout 60 * 60  # increase timeout to 60 mins
       cwd full_name
       code "./gradlew #{target}"
      end
    when 'mvn'
      bash "compile_project" do
       timeout 60 * 60  # increase timeout to 60 mins
       cwd full_name
       code 'mvn clean install -DskipTests'
      end
    else
      raise "Unsupported backend " + backend
  end

  bash "fix_permissions" do
   cwd path
   code "chmod -R 0777 #{full_name}"
  end

end
