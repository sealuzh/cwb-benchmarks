# CLI-benchmark

Cloud WorkBench (CWB) helper cookbook which allows to define simple benchmarks that do not require a cookbook.

## Supported Platforms

* Ubuntu 14.04 LTS 64 bit (manually tested)
* Ubuntu 16.04 LTS 64 bit (manually tested)
* Ubuntu 18.04 LTS 64 bit (manually tested 2019-01-04)

## Attributes

See `attributes/default.rb`

## Usage

### Cloud WorkBench

| Metric Name                  | Unit              | Scale Type    |
| ---------------------------- | ----------------- | ------------- |
| *metric_name*                | *unit*            | ratio/nominal |
| instance/cpu_model           | model name        | nominal       |
| instance/cpu_cores           | count             | ratio         |
| instance/ram_total           | kB                | nominal       |

### cli-benchmark::default

Add the `cli-benchmark` default recipe to your Chef configuration:

```ruby
config.vm.provision "chef_client", id: "chef_client" do |chef|
  chef.add_recipe "cli-benchmark" # @x.x.x version is optional
  chef.json =
  {
    'cli-benchmark' => {
        'packages' => %w(vim sysbench),
        # Strive for idempotency here (i.e., multiple executions shouldn't crash)
        'install' => [
          'mkdir -p /usr/local/sysbench',
          'cd /usr/local/sysbench',
          '[ -e file.tar.gz ] && wget http://example.com/folder/file.tar.gz',
          'tar -xzf file.tar.gz',
        ],
        'pre_run' => 'echo "This will be run immediately BEFORE the benchmark starts" > log.txt',
        'run' => 'sysbench --test=cpu --cpu-max-prime=20000 run',
        # Repetitions include pre_run and post_run
        'repetitions' => 3,
        'post_run' => 'echo "This will be run immediately AFTER the benchmark ends" > log.txt',
        'metrics' => {
          # [name of the metric] => [regex to extract result from stdout]
          'execution_time' => 'total time:\s*(\d+\.\d+)s',
        }
    }
  }
end
```

## License and Authors

Author:: Joel Scheuner (joel.scheuner.dev@gmail.com)
