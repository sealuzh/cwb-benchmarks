# sysbench-monitored

Uses the sysbench cwb benchmark and extends it with active monitoring during benchmark execution.

## Supported Platforms

* Ubuntu 14.04 LTS (manually tested)

## Attributes

See `sysbench` for benchmark related attributes

See `attributes/default.rb` for monitoring related attributes

## Usage

### Cloud WorkBench

| Metric Name                  | Unit              | Scale Type    |
| ---------------------------- | ----------------- | ------------- |
| **execution_time**           | seconds           | ratio         |
| **sar_user**                 | %user             | ratio         |
| **sar_steal**                | %steal            | ratio         |
| **sar_idle**                 | %idle             | ratio         |
| cpu                          | model name        | nominal       |

### Sysbench Reference

* [Ubuntu Manuals](http://manpages.ubuntu.com/manpages/trusty/man1/sysbench.1.html)
* [Sysbench Tutorial](http://www.howtoforge.com/how-to-benchmark-your-system-cpu-file-io-mysql-with-sysbench)

### sysbench::default

Add the `sysbench-monitored` default recipe to your Chef configuration in the Vagrantfile:

```ruby
config.vm.provision 'chef_client' do |chef|
  chef.add_recipe 'sysbench-monitored'
  chef.json =
  {
    'sysbench' => {
        'cli_options' => {
            'test' => 'cpu',
            'cpu-max-prime' => 4_000,
        }
    },
    'sysbench-monitored' => {
      'runtime' => 2 * 60,
      'sar_interval' => 2,
      'sleeptime' => 10,
    }
  }
end
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Joel Scheuner (joel.scheuner.dev@gmail.com)
