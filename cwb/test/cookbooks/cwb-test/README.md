# cwb-test

**NOTE**: This cookbook is used with test-kitchen to test the parent, cwb cookbok.

Installs the `cwb-test` benchmark and provides utilities to integrate with Cloud WorkBench.

## Attributes

See `attributes/default.rb`

## Usage

### Cloud WorkBench

| Metric Name                  | Unit              | Scale Type    |
| ---------------------------- | ----------------- | ------------- |
| **metric-name**              | unit              | ratio/nominal |
| cpu                          | model-name        | nominal       |

**bold-written** metrics are mandatory

### cwb-test::default

Add the `cwb-test` default recipe to your Chef configuration in the Vagrantfile:

```ruby
config.vm.provision 'chef_client', id: 'chef_client' do |chef|
  chef.add_recipe 'cwb-test@0.1.0'  # Version is optional
  chef.json =
  {
    'cwb-test' => {
        'metric_name' => 'execution-time',
    },
  } # END json
end
```

## License and Authors

Author:: YOUR_NAME (<YOUR_EMAIL>)
