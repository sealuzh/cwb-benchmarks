# wordpress-bench

Installs the `wordpress-bench` benchmark and provides utilities to integrate with Cloud WorkBench.

## Attributes

See `attributes/default.rb`

## Usage

### Cloud WorkBench

| Metric Name                  | Unit              | Scale Type    |
| ---------------------------- | ----------------- | ------------- |
| **metric-name**              | unit              | ratio/nominal |
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
        'metric_name' => 'execution_time',
    },
  } # END json
end
```

## License and Authors

Author:: YOUR_NAME (<YOUR_EMAIL>)
