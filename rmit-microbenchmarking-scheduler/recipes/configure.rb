# Declare a CWB benchmark
# Make sure you create the corresponding
# benchmark file in files/default/benchmark_name.rb
cwb_benchmark_suite 'rmit-microbenchmarking-scheduler'

include_recipe 'jmh-runner'
include_recipe 'go-runner'
