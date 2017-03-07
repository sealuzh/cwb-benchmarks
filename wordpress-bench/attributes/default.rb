# Cloud WorkBench
default['wordpress-bench']['metric_name'] = 'response_time'
default['wordpress-bench']['num_repetitions'] = 1

# Fake data generator
default['wordpress-bench']['500px_customer_key'] = ''
default['wordpress-bench']['batch_size'] = 25

# Load generator endpoint
default['wordpress-bench']['load_generator'] = 'http://localhost'

# Cookbook wherein the `test_plan.jmx` resides
default['wordpress-bench']['test_plan_cookbook'] = 'wordpress-bench'

http_site = node['wordpress']['site']['url']
# JMeter properties
default['wordpress-bench']['jmeter']['properties']['site'] = (http_site.sub('http://', '') rescue '127.0.0.1')
# Thread-group specific
default['wordpress-bench']['jmeter']['properties']['target_concurrency'] = 80 # i.e., users
default['wordpress-bench']['jmeter']['properties']['ramp_up_time'] = 5 # time while the users are gradually increased
default['wordpress-bench']['jmeter']['properties']['ramp_up_steps_count'] = 7 # number of steps from 0 to [target_concurrency]
default['wordpress-bench']['jmeter']['properties']['hold_target_rate_time'] = 2 # time to hold the target load
