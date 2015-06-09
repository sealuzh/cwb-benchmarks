extend WordpressBench::Helpers

# Cloud WorkBench
default['wordpress-bench']['metric_name'] = 'response_time'

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

# Fake data generator
default['wordpress-bench']['500px_customer_key'] = ''
default['wordpress-bench']['batch_size'] = 25

# Load generator endpoint
default['wordpress-bench']['load_generator'] = 'http://localhost'

# JMeter properties
default['wordpress-bench']['jmeter']['properties']['site'] = default_ip
default['wordpress-bench']['jmeter']['properties']['httpclient.timeout'] = 60 * 1000 # milliseconds
