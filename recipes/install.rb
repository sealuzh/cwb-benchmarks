FARADAY_VERSION = '~> 0.9.1'
chef_gem 'faraday' do
  compile_time true if respond_to?(:compile_time)
  options '--no-document'
  version FARADAY_VERSION
end

chef_gem 'faraday_middleware' do
  compile_time true if respond_to?(:compile_time)
  options '--no-document'
  version FARADAY_VERSION
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
  compile_time true if respond_to?(:compile_time)
  source CWB_GEM_PATH
  options('--no-document')
end
