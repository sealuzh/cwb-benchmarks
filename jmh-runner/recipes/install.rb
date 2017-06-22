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

include_recipe 'jmh-runner::clone_build_projects'
