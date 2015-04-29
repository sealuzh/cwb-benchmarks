# Time the benchmark will run in seconds
default['sysbench-monitored']['runtime'] = 40 * 60
# Interval in seconds (sar will collect metrics every x seconds)
default['sysbench-monitored']['sar_interval'] = 60

# Introduce idleness before and after the benchmark
# in order to get baseline cpu utilization
default['sysbench-monitored']['sleeptime'] = 2 * 60
