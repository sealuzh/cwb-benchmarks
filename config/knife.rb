# For further options see: http://docs.opscode.com/config_rb_knife.html

# TODO:
# 1. Update CHEF_SERVER and REPO_ROOT
# 2. Copy this file to ~/.chef/knife.rb

# MUST match with what is configured as api_fqdn on the chef-server (either IP or FQDN)
CHEF_SERVER = 'A.B.C.D'
# Path to git repository
REPO_ROOT = "#{ENV['HOME']}/git/cwb-benchmarks"


CURRENT_DIR = File.dirname(__FILE__)

### Chef client
node_name                'cwb-user'
client_key               File.join(CURRENT_DIR, 'cwb-user.pem')
chef_server_url          "https://#{CHEF_SERVER}:443"
# Fix for self-signed SSL certificate of Chef server
ssl_verify_mode          :verify_none
cookbook_path            [ REPO_ROOT ]

### Validator (optionally used to create new Chef nodes)
# validation_client_name   'chef-validator'
# validation_key           File.join(CURRENT_DIR, 'chef_validator.pem')

### General
log_level                :info
log_location             STDOUT
syntax_check_cache_path  File.join(CURRENT_DIR, 'syntax_check_cache')

### Organization and Personal
# cookbook_copyright 'YOUR ORGANIZATION'
cookbook_license 'MIT'
# cookbook_email 'YOUR EMAIL'
