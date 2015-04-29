default['sysbench']['metrics']['execution_time'] = 'execution_time'
default['sysbench']['metrics']['cpu'] = 'cpu'
num_cores = node['cpu']['total'] rescue 1
default['sysbench']['cli_options']['test'] = 'cpu'
default['sysbench']['cli_options']['num-threads'] = num_cores
default['sysbench']['cli_options']['cpu-max-prime'] = 20_000
