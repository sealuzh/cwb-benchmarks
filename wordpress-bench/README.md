# wordpress-bench

Installs the `wordpress-bench` benchmark and provides utilities to integrate with Cloud WorkBench.

Currently uses a dedicated load generator server https://github.com/joe4dev/load-generator.

## Dependencies

* Worpress cookbook: https://supermarket.chef.io/cookbooks/wordpress
* Worpress plugin `FakerPress`: https://wordpress.org/plugins/fakerpress/
    * Github: https://github.com/bordoni/fakerpress
* Wordpress plugin `Disable check comment flood`: https://wordpress.org/plugins/disable-check-comment-flood

## Attributes

See `attributes/default.rb`

## Usage

### Cloud WorkBench

| Metric Name                  | Unit              | Scale Type    |
| ---------------------------- | ----------------- | ------------- |
| **response_time**            | milliseconds      | ratio         |
| num_failures                 | count             | ratio         |
| failure_rate                 | ratio             | ratio         |
| cpu                          | model-name        | nominal       |

**bold-written** metrics are mandatory

### wordpress-bench::default

Add the `wordpress-bench` default recipe to your Chef configuration in the Vagrantfile:

```ruby
config.vm.provision 'chef_client', id: 'chef_client' do |chef|
  chef.add_recipe 'wordpress-bench@0.1.0'  # Version is optional
  chef.json =
  {
    'wordpress-bench' => {
        'metric_name' => 'response_time',
        'num_repetitions' => 1,
        'load_generator' => 'http://192.168.33.44',
        # Used to generate sample images
        '500px_customer_key' => 'YOUR_CUSTOMER_KEY',
        'jmeter' => {
            'properties' => {
                # i.e., users
                'num_threads' => 2,
                'ramp_up_period' => 0,
            },
        },
    },
  }
end
```

## Troubleshooting

The wordpress cookbook causes some database issues when stopping or restarting the machine. Simply reprovision and `install.rb` will fix this issue. See https://github.com/brint/wordpress-cookbook/issues/55

## License and Authors

Author:: Joel Scheuner (joel.scheuner.dev@gmail.com)
