extend WordpressBench::Helpers

# Cloud WorkBench
default['wordpress-bench']['metric_name'] = 'execution_time'

# wp-cli
default['wordpress-bench']['wp_cli_url'] = 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar'
default['wordpress-bench']['wp_cli_bin'] = '/usr/local/bin/wp'

# General
default['wordpress-bench']['public_ip_query'] = 'wget http://ipecho.net/plain -O - -q'

# Wordpress site
default['wordpress-bench']['url'] = "http://#{default_ip}"
default['wordpress-bench']['title'] = 'Cloud Benchmarking'
default['wordpress-bench']['admin_user'] = 'admin'
default['wordpress-bench']['admin_password'] = 'admin'
default['wordpress-bench']['admin_email'] = 'admin@example.com'
