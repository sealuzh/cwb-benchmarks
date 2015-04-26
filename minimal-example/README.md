# minimal-example

Installs the `minimal-example` benchmark and provides utilities to integrate with Cloud WorkBench.

## Attributes

See `attributes/default.rb`

## Usage

### Cloud WorkBench

| Metric Name                  | Unit              | Scale Type    |
| ---------------------------- | ----------------- | ------------- |
| **execution-time**           | seconds           | ratio         |

**bold-written** metrics are mandatory

### benchmark-name::default

Add the `minimal-example` default recipe to your Chef configuration in the Vagrantfile:

```ruby
config.vm.provision 'chef_client', id: 'chef_client' do |chef|
  chef.add_recipe 'minimal-example@0.1.0'  # Version is optional
  chef.json =
  {
    'minimal-example' => {
        'cpu_max_prime' => 3_000,
    },
  } # END json
end
```

## License and Authors

Author:: Joel Scheuner (joel.scheuner.dev@gmail.com)a

