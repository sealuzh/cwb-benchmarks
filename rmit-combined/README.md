# rmit-combined

This benchmark implements the `Randomized Multiple Interleaved Trials (RMIT)` methodology as a cwb `BenchmarkSuite`. It further defines a collection of micro and application benchmarks.

## Attributes

See `attributes/default.rb`

## Usage

### Cloud WorkBench

| Metric Name                  | Unit                   | Scale Type    |
| ---------------------------- | ---------------------- | ------------- |
| cpu-model                    | model name             | nominal       |
| cpu-cores                    | number of cores        | nominal       |
| ram-total                    | total ram in kb        | nominal       |
| benchmark-order              | ordered benchmark list | nominal       |
| gcc-version                  | version number         | nominal       |
| sysbench/version             | version number         | nominal       |
| sysbench/cpu-single-thread   | execution time         | nominal       |
| sysbench/cpu-multi-thread    | execution time         | nominal       |
| sysbench/memory-default-block-size | execution time   | nominal       |
| sysbench/memory-large-block-size   | execution time   | nominal       |
| sysbench/memory-default-block-size-throughput | throughput       | nominal       |
| sysbench/memory-large-block-size-throughput   | throughput       | nominal       |
| sysbench/threads-1           | execution time         | nominal       |
| sysbench/threads-128         | execution time         | nominal       |
| sysbench/threads-1-latency   | average latency        | nominal       |
| sysbench/threads-128-latency | average latency        | nominal       |
| sysbench/mutex               | execution time         | nominal       |
| sysbench/mutex-latency       | average latency        | nominal       |
| sysbench/fileio-file-total-size | GB                  | nominal       |
| sysbench/fileio-1m-seq-write | execution time         | nominal       |
| sysbench/fileio-1m-seq-write-throughput | throughput  | nominal       |
| sysbench/fileio-1m-seq-write-latency | average latency | nominal |
| sysbench/fileio-1m-seq-write-latency-95-percentile  | 95% latency percentile | nominal |
| sysbench/fileio-4k-rand-write | execution time | nominal |
| sysbench/fileio-4k-rand-write-throughput  | throughput | nominal |
| sysbench/fileio-4k-rand-write-latency | average latency | nominal |
| sysbench/fileio-4k-rand-write-latency-95-percentile | 95% latency percentile | nominal |
| sysbench/fileio-4k-rand-read  | execution time | nominal |
| sysbench/fileio-4k-rand-read-throughput | throughput | nominal |
| sysbench/fileio-4k-rand-read-latency  | average latency | nominal |
| sysbench/fileio-4k-rand-read-latency-95-percentile  | 95% latency percentile | nominal |
| fio/version                  | version number         | nominal       |
| fio/4k-seq-write-bandwidth | bandwidth | nominal |
| fio/4k-seq-write-iops | iops | nominal |
| fio/4k-seq-write-latency | microseconds | nominal |
| fio/4k-seq-write-latency-95-percentile | microseconds | nominal |
| fio/4k-seq-write-disk-util | utilization | nominal |
| fio/8k-rand-write-bandwidth | bandwidth | nominal |
| fio/8k-rand-write-iops | iops | nominal |
| fio/8k-rand-write-latency | microseconds | nominal |
| fio/8k-rand-write-latency-95-percentile | microseconds | nominal |
| fio/8k-rand-write-disk-util | utilization | nominal |
| stressng/version | version number | nominal |
| stressng/cpu-callfunc-bogo-ops | bogo operations per second | nominal |
| stressng/cpu-double-bogo-ops | bogo operations per second | nominal |
| stressng/cpu-euler-bogo-ops | bogo operations per second | nominal |
| stressng/cpu-fibonacci-bogo-ops | bogo operations per second | nominal |
| stressng/cpu-fft-bogo-ops | bogo operations per second | nominal |
| stressng/cpu-int64-bogo-ops | bogo operations per second | nominal |
| stressng/cpu-loop-bogo-ops | bogo operations per second | nominal |
| stressng/cpu-matrixprod-bogo-ops | bogo operations per second | nominal |
| stressng/network | execution time | nominal |
| stressng/network-epoll-bogo-ops | bogo operations per second | nominal |
| stressng/network-icmp-flood-bogo-ops | bogo operations per second | nominal |
| stressng/network-sockfd-bogo-ops | bogo operations per second | nominal |
| stressng/network-udp-bogo-ops | bogo operations per second | nominal |
| iperf/version | version number | nominal |
| iperf/single_thread | bandwidth | nominal |
| iperf/multi_thread | bandwidth | nominal |

**bold-written** metrics are mandatory

### rmit-combined::default

Add the `rmit-combined` default recipe to your Chef configuration in the Vagrantfile:

```ruby
config.vm.provision 'cwb', type: 'chef_client' do |chef|
  chef.add_recipe 'rmit-combined@0.1.0'  # Version is optional
  chef.json =
  {
    'rmit-combined' => {
        'repetitions' => 3,
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
