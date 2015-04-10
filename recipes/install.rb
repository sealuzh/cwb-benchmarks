# TODO: Replace HTTP client to remove rest-client dependency
# because rest-client requires build-essential to be installed.
# Alternatives:
# * chef_gem 'httparty' # first time: 13s; then 4s
# * chef_gem 'excon' # first time 12s; then 4s
node.set['build-essential']['compile_time'] = true
include_recipe 'build-essential::default'
chef_gem 'rest-client' do
  compile_time true
end

CWB_GEM_VERSION = '0.0.1'
CWB_GEM = "cwb-#{CWB_GEM_VERSION}.gem"
CWB_GEM_PATH = File.join(Chef::Config[:file_cache_path], 'cookbooks', 'cwb', 'files', 'default', CWB_GEM)
# Directly read gem from the file_cache_path where Chefs stores all cookbooks
# StackOverflow explanation: http://stackoverflow.com/a/24975647
# If you want to properly resolve the local file path (e.g., platform dependent files) you might
# want to have a look at how Chef is doing this within the cookbook_file implementation:
# https://github.com/chef/chef/blob/master/lib/chef/provider/cookbook_file/content.rb
# using preferred_filename_on_disk_location(NODE, :files, SOURCE)
# This method is defined here: https://github.com/chef/chef/blob/master/lib/chef/cookbook_version.rb
chef_gem 'cwb' do
  compile_time true
  source CWB_GEM_PATH
  options('--no-document')
end
