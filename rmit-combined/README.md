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
| benchmark-order              | ordered benchmark list | nominal       |
| sysbench/version             | version number         | nominal       |
| sysbench/cpu-single-thread   | execution time         | nominal       |
| sysbench/cpu-multi-thread    | execution time         | nominal       |
| sysbench/memory-default-block-size    | throughput         | nominal       |
| sysbench/memory-large-block-size    | throughput         | nominal       |

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

## License and Authors

Author:: Joel Scheuner (joel.scheuner.dev@gmail.com)
