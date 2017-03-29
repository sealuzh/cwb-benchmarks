cwb_benchmark_suite 'rmit-benchmark-suite'

# Implementations provided under `files/default/benchmark_name.rb`
cwb_benchmark 'sysbench-cpu'
cwb_benchmark 'sysbench-memory'
cwb_benchmark 'sysbench-threads'
cwb_benchmark 'sysbench-mutex'
cwb_benchmark 'sysbench-fileio'
cwb_benchmark 'fio'
cwb_benchmark 'stressng-cpu'
cwb_benchmark 'stressng-network'
cwb_benchmark 'iperf'
include_recipe 'rmit-combined::configure_remote_client'
cwb_benchmark 'md-sim'

### Wordpress Benchmark
def config_jmeter(properties)
  properties.each do |prop, value|
    node.default['wordpress-bench']['jmeter']['properties'][prop] = value
  end
end

props = {
  'target_concurrency' => 10,
  'ramp_up_time' => 0,
  'ramp_up_steps_count' => 1,
  'hold_target_rate_time' => 1,
  'forcePerfmonFile' => true,
}
config_jmeter(props)
# Automatically adds `cwb_benchmark 'wordpress-bench`
include_recipe 'wordpress-bench'
include_recipe 'perfmon'

# Make sure that unnecessary services are stopped
node.default['stop-services']['stop_list'] = %w(cron rsyslog atd)
include_recipe 'stop-services'
include_recipe 'wordpress-bench::stop_services'
