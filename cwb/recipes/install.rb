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

# Using `preferred_filename_on_disk_location` is a more reliable way to grab the cookbook files
#  from internal storage than using Chef's `file_cache_path`. The alternative didn't work with chef-solo:
# File.join(Chef::Config[:file_cache_path], 'cookbooks', 'cwb', 'files', 'default', CWB_GEM)
# StackOverflow "How to read cookbook file at recipe compilation time?": http://stackoverflow.com/a/24975647
# If you want to properly resolve the local file path (e.g., platform dependent files) you might
# want to have a look at how Chef is doing this within the cookbook_file implementation:
# https://github.com/chef/chef/blob/master/lib/chef/provider/cookbook_file/content.rb
# using `preferred_filename_on_disk_location(NODE, :files, SOURCE)`
# This method is defined here: https://github.com/chef/chef/blob/master/lib/chef/cookbook_version.rb
def cwb_dev_gem(version)
  cwb_gem = "cwb-#{version}.gem"
  @run_context.cookbook_collection['cwb'].preferred_filename_on_disk_location(node, :files, cwb_gem)
end

DEV_GEM = false
chef_gem 'cwb' do
  compile_time true if respond_to?(:compile_time)
  source cwb_dev_gem('0.1.0') if DEV_GEM
  options('--no-document')
end
