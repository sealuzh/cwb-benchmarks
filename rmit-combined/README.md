# rmit-combined

This benchmark implements the `Randomized Multiple Interleaved Trials (RMIT)` methodology as a cwb `BenchmarkSuite`. It further defines a collection of micro and application benchmarks.

## Attributes

See `attributes/default.rb` for all details or the Vagrantfile usage example below.

## Usage

### Cloud WorkBench

* All metrics are `nominal` scale to unify the DB export process
* Suffixes:
  * duration: execution time (prepare-duration: preparation time)
  * version: version number

| Metric Name                  | Unit                   |
| ---------------------------- | ---------------------- |
| benchmark/execution-log | {benchmark class name}\_{START or END} |
| benchmark/order | [{benchmark class name}, ...] |
| fio/4k-seq-write-bandwidth | KiB/s |
| fio/4k-seq-write-disk-util | % |
| fio/4k-seq-write-duration | milliseconds |
| fio/4k-seq-write-iops | iops |
| fio/4k-seq-write-latency | microseconds |
| fio/4k-seq-write-latency-95-percentile | microseconds |
| fio/8k-rand-write-bandwidth | KiB/s |
| fio/8k-rand-write-disk-util | % |
| fio/8k-rand-write-iops | iops |
| fio/8k-rand-write-latency | microseconds |
| fio/8k-rand-write-latency-95-percentile | microseconds |
| fio/version | version number |
| instance/cpu-cores | number of cores |
| instance/cpu-model | model name |
| instance/gcc-version | version number |
| instance/ram-total | kB |
| iperf/multi-thread-bandwidth | Mbits/sec or Gbits/sec |
| iperf/multi-thread-duration | seconds |
| iperf/single-thread-bandwidth | Mbits/sec or Gbits/sec |
| iperf/single-thread-duration | seconds |
| iperf/version | version number |
| md-sim-duration | seconds |
| stressng/cpu-callfunc-bogo-ops | bogo operations per second |
| stressng/cpu-callfunc-duration | seconds |
| stressng/cpu-double-bogo-ops | bogo operations per second |
| stressng/cpu-double-duration | seconds |
| stressng/cpu-euler-bogo-ops | bogo operations per second |
| stressng/cpu-euler-duration | seconds |
| stressng/cpu-fft-bogo-ops | bogo operations per second |
| stressng/cpu-fft-duration | seconds |
| stressng/cpu-fibonacci-bogo-ops | bogo operations per second |
| stressng/cpu-fibonacci-duration | seconds |
| stressng/cpu-int64-bogo-ops | bogo operations per second |
| stressng/cpu-int64-duration | seconds |
| stressng/cpu-loop-bogo-ops | bogo operations per second |
| stressng/cpu-loop-duration | seconds |
| stressng/cpu-matrixprod-bogo-ops | bogo operations per second |
| stressng/cpu-matrixprod-duration | seconds |
| stressng/network-epoll-bogo-ops | bogo operations per second |
| stressng/network-icmp-flood-bogo-ops | bogo operations per second |
| stressng/network-sockfd-bogo-ops | bogo operations per second |
| stressng/network-total-duration | seconds |
| stressng/network-udp-bogo-ops | bogo operations per second |
| stressng/version | version number |
| sysbench/cpu-multi-thread-duration | seconds |
| sysbench/cpu-single-thread-duration | seconds |
| sysbench/fileio-1m-seq-write-duration | seconds |
| sysbench/fileio-1m-seq-write-latency | milliseconds |
| sysbench/fileio-1m-seq-write-latency-95-percentile | milliseconds |
| sysbench/fileio-1m-seq-write-throughput | Mb/s |
| sysbench/fileio-4k-rand-read-duration  | seconds |
| sysbench/fileio-4k-rand-read-latency | milliseconds |
| sysbench/fileio-4k-rand-read-latency-95-percentile | milliseconds |
| sysbench/fileio-4k-rand-read-prepare-duration  | seconds |
| sysbench/fileio-4k-rand-read-throughput | Mb/s |
| sysbench/fileio-4k-rand-write-duration | seconds |
| sysbench/fileio-4k-rand-write-latency | milliseconds |
| sysbench/fileio-4k-rand-write-latency-95-percentile | milliseconds |
| sysbench/fileio-4k-rand-write-throughput | Mb/s |
| sysbench/fileio-file-total-size | GB |
| sysbench/memory-default-block-size-duration | seconds |
| sysbench/memory-default-block-size-throughput | throughput (MB/s) |
| sysbench/memory-large-block-size-duration | execution time (s) |
| sysbench/memory-large-block-size-throughput | throughput (MB/s) |
| sysbench/mutex-duration | seconds |
| sysbench/mutex-latency | milliseconds |
| sysbench/threads-1-duration | seconds |
| sysbench/threads-1-latency | milliseconds |
| sysbench/threads-128-duration | seconds |
| sysbench/threads-128-latency | milliseconds |
| sysbench/version | version number |
| wordpress-bench/s1-failure_rate  | ratio |
| wordpress-bench/s1-num_failures  | count |
| wordpress-bench/s1-response_time | milliseconds |
| wordpress-bench/s1-throughput    | operations per second |
| wordpress-bench/s2-failure_rate  | ratio |
| wordpress-bench/s2-num_failures  | count |
| wordpress-bench/s2-response_time | milliseconds |
| wordpress-bench/s2-throughput    | operations per second |
| wordpress-bench/s3-failure_rate  | ratio |
| wordpress-bench/s3-num_failures  | count |
| wordpress-bench/s3-response_time | milliseconds |
| wordpress-bench/s3-throughput    | operations per second |

### rmit-combined::default

Add the `rmit-combined` default recipe to your Chef configuration in the Vagrantfile:

```ruby
config.vm.provision 'cwb', type: 'chef_client' do |chef|
  chef.add_recipe 'rmit-combined'
  chef.json =
  {
    'rmit-combined' => {
        'repetitions' => 3,
        'load_generator' => '172.31.10.209',
    },
  }
end
```

## Testing

Prepare: Install Ruby dependencies via `bundle install`

```shell
cd spec/
rspec .
```

## License and Authors

Author:: Joel Scheuner (joel.scheuner.dev@gmail.com)
