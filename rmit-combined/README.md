# rmit-combined

This benchmark implements the `Randomized Multiple Interleaved Trials (RMIT)` methodology as a cwb `BenchmarkSuite`. It further defines a collection of micro and application benchmarks.

## Attributes

See `attributes/default.rb`

## Usage

### Cloud WorkBench

| Metric Name                  | Unit              | Scale Type    |
| ---------------------------- | ----------------- | ------------- |
| cpu                          | model-name        | nominal       |
| benchmark-order              | model-name        | nominal       |


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
