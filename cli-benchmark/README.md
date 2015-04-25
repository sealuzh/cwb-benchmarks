# CLI-benchmark

Cloud WorkBench (CWB) helper cookbook which allows to define simple benchmarks that do not require a cookbook.

## Supported Platforms

* Ubuntu 14.04 LTS 64 bit (manually tested)

## Attributes

See `attributes/default.rb`

## Usage

### Cloud WorkBench

* Create a metric called `node['cli-benchmark']['metric']` (depends on specific benchmark)
* Create a nominal-scale metric called `cpu` which reports the `model name` (OPTIONAL)

### cli-benchmark::default

Add the `cli-benchmark` default recipe to your Chef configuration:

```ruby
config.vm.provision "chef_client", id: "chef_client" do |chef|
  chef.add_recipe "cli-benchmark@1.0.0"  # Version is optional
  chef.json =
  {
    'cli-benchmark' => {
        'packages' => [vim, sysbench],
        'install' => 'echo "SUCCESS" > install.txt',
        'pre_run' => 'echo "SUCCESS" > pre_run.txt',
        'run' => 'sysbench --test=cpu --cpu-max-prime=20000 run',
        'regex' => 'total time:\s*(\d+\.\d+)s',
        'metric' => 'time'
    }
  }
end
```

## License and Authors

Author:: Joel Scheuner (joel.scheuner.dev@gmail.com)
