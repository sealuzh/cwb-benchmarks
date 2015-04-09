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
CWB_GEM_PATH = File.join(Chef::Config[:file_cache_path], CWB_GEM)
cookbook_file CWB_GEM_PATH do
  source CWB_GEM
end

chef_gem 'cwb' do
  compile_time true
  source CWB_GEM_PATH
  options('--no-document')
end
