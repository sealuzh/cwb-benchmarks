### Install your benchmark here by leveraging
# Chef resources: http://docs.chef.io/resources.html
# Community cookbooks: https://supermarket.chef.io/dashboard

## Example:
# Update apt package index (make sure you declare dependencies in metadata.rb)
include_recipe 'apt'
package 'default-jdk'
package 'maven'
package 'git'
gem_package 'git'

projects = node['jmh-runner']['projects']
puts "Starting to install Java projects to benchmark"
projects.each do |project|

  # clone and checkout repo
  group = project['project']['github']['group']
  name = project['project']['github']['name']
  url = "https://github.com/%s/%s.git" % [group, name]

  puts "Installing #{url}"

  bash "clone_project" do
   cwd '../files/default'
   code "git clone #{url}"
   version = project['project']['version']
   if version
     cwd name
     code "git checkout #{version}"
   end
   puts "Successfully cloned and checked out project"
   action :nothing
  end

  # compile using the appropriate backend
  backend = project['project']['backend']
  case backend
    when 'gradle'
      target = project['project']['gradle']['build_cmd']
      bash "compile_project" do
       cwd name
       code "./gradlew #{target}"
       action :nothing
      end
    when 'mvn'
      bash "compile_project" do
       cwd name
       code 'mvn clean install -DskipTests'
       action :nothing
      end
    else
      raise "Unsupported backend " + backend
  end
  puts "Successfully compiled project"

end
