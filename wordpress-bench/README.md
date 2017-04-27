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

* All metrics are `nominal` scale to unify the DB export process

| Metric Name                      | Unit           |
| -------------------------------- | -------------- |
| wordpress-bench/s1-response_time | milliseconds   |
| wordpress-bench/s1-throughput    | operations per second |
| wordpress-bench/s1-num_failures  | count          |
| wordpress-bench/s1-failure_rate  | ratio          |
| wordpress-bench/s2-response_time | milliseconds   |
| wordpress-bench/s2-throughput    | operations per second |
| wordpress-bench/s2-num_failures  | count          |
| wordpress-bench/s2-failure_rate  | ratio          |
| wordpress-bench/s3-response_time | milliseconds   |
| wordpress-bench/s3-throughput    | operations per second |
| wordpress-bench/s3-num_failures  | count          |
| wordpress-bench/s3-failure_rate  | ratio          |

### Testplan migration

See `files/default/update_testplan.rb`

Whenever a new data set is created, the URLs of the image resources need to be migrated. Given a hostname of an instance running the target data set, the update script automatically rewrites the test plan URLs and yields a list of samplers to disable.

Encapsulate the new `test_plan.jmx` into a cookbook and add it to the Chef run list BEFORE the wordpress benchmark. See `test-plan-aws-pv`.

### wordpress-bench::default

Add the `wordpress-bench` default recipe to your Chef configuration in the Vagrantfile:

```ruby
config.vm.provision 'chef_client' do |chef|
  chef.add_recipe 'wordpress-bench'
  chef.json =
  {
    'wordpress-bench' => {
        'num_repetitions' => 1,
        'load_generator' => '192.168.33.44',
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

## Remote JMeter Testing

NOTICE: The slaves must be in the same subnet. Therefore, we use private IP addresses here.

```ruby
'wordpress-bench' => {
    'jmeter' => {
        'runremote' => true,
        'properties' => {
            'remote_hosts' => '172.31.7.214' # or '172.31.7.214,172.31.7.215'
        }
    }
}
```

## Troubleshooting

1) Restarting the VM yields the error `Error establishing a database connection`. Reprovision the `wordpress` recipe will fix this issue. See [fix](https://github.com/joe4dev/wordpress/commit/9385b53564edf683bd3a70a846d6d9daf593900a) and [discussion](https://github.com/brint/wordpress-cookbook/issues/55).

## License and Authors

Author:: Joel Scheuner (joel.scheuner.dev@gmail.com)
