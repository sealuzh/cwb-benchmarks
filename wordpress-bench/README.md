# wordpress-bench

Installs the `wordpress-bench` benchmark and provides utilities to integrate with Cloud WorkBench.

Currently uses a dedicated load generator server https://github.com/joe4dev/load-generator.

## Dependencies

* Adapted [wordpress](https://supermarket.chef.io/cookbooks/wordpress) cookbook: https://github.com/joe4dev/wordpress
* WordPress plugin `FakerPress`: https://wordpress.org/plugins/fakerpress/
    * Github: https://github.com/bordoni/fakerpress
* WordPress plugin `Disable check comment flood`: https://wordpress.org/plugins/disable-check-comment-flood

## Attributes

See `attributes/default.rb`

Use the attribute `['wordpress-bench']['test_plan_cookbook']` to configure an alternative cookbook that provides the test plan under `files/default/test_plan.jmx`.

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
config.vm.provision 'chef_client' do |chef|
  chef.add_recipe 'wordpress-bench@2.0.0'  # Version is optional
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

## Troubleshooting

1) Restarting the VM yields the error `Error establishing a database connection`. Reprovision the `wordpress` recipe will fix this issue. See [fix](https://github.com/joe4dev/wordpress/commit/9385b53564edf683bd3a70a846d6d9daf593900a) and [discussion](https://github.com/brint/wordpress-cookbook/issues/55).

## License and Authors

Author:: Joel Scheuner (joel.scheuner.dev@gmail.com)
