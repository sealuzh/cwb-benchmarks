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
