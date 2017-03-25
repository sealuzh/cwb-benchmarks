# wordpress-bench-test-plan

Encapsulates the `test_plan.jmx` for the `wordpress-bench` benchmark.

## Attributes

See `wordpress-bench`

## Usage

See `wordpress-bench`

### wordpress-bench-test-plan::default

Add the `wordpress-bench-test-plan` default recipe to your Chef configuration in the Vagrantfile:

```ruby
config.vm.provision 'chef_client' do |chef|
  chef.add_recipe 'wordpress-bench-test-plan'
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
                'target_concurrency' => 180,
                'ramp_up_time' => 6,
                'ramp_up_steps_count' => 9,
                'hold_target_rate_time' => 3,
            },
        },
    },
  }
end
```


## License and Authors

Author:: Joel Scheuner (joel.scheuner.dev@gmail.com)
