require 'fileutils'

projects = node['jmh-runner']['projects']
path = Cwb::BenchmarkUtil.new('jmh-runner', node).path
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
   puts "Successfully cloned project"
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
       timeout 30 * 60  # increase timeout to 30 mins
       cwd full_name
       code "./gradlew #{target}"
      end
    when 'mvn'
      bash "compile_project" do
       timeout 30 * 60  # increase timeout to 30 mins
       cwd full_name
       code 'mvn clean install -DskipTests'
      end
    else
      raise "Unsupported backend " + backend
  end
  puts "Successfully compiled project"

end
