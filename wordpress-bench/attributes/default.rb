# Cloud WorkBench
default['wordpress-bench']['metric_name'] = 'response_time'
default['wordpress-bench']['num_repetitions'] = 1

# Fake data generator
default['wordpress-bench']['500px_customer_key'] = ''
default['wordpress-bench']['batch_size'] = 25

# Load generator endpoint
default['wordpress-bench']['load_generator'] = 'http://localhost'

http_site = node['wordpress']['site']['url']
# JMeter properties
default['wordpress-bench']['jmeter']['properties']['site'] = (http_site.sub('http://', '') rescue '127.0.0.1')
default['wordpress-bench']['jmeter']['properties']['httpclient.timeout'] = 60 * 1000 # in milliseconds (x seconds * 1000)
default['wordpress-bench']['jmeter']['properties']['num_threads'] = 2 # i.e., users
default['wordpress-bench']['jmeter']['properties']['ramp_up_period'] = 0 # seconds
