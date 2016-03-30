# molecular-dynamics-simulation

Installs the `molecular-dynamics-simulation` benchmark and provides utilities to integrate with Cloud WorkBench.

## Attributes

See `attributes/default.rb`

## Usage

### Cloud WorkBench

| Metric Name                  | Unit              | Scale Type    |
| ---------------------------- | ----------------- | ------------- |
| **execution_time**           | seconds           | ratio         |
| cpu                          | model-name        | nominal       |

**bold-written** metrics are mandatory

### molecular-dynamics-simulation::default

Add the `molecular-dynamics-simulation` default recipe to your Chef configuration in the Vagrantfile:

```ruby
config.vm.provision 'chef_client' do |chef|
  chef.add_recipe 'molecular-dynamics-simulation@0.1.0'  # Version is optional
  chef.json =
  {
    'molecular-dynamics-simulation' => {
        'metric_name' => 'execution_time',
        # Determines the simulation size
        'np' => 10_000,
    },
  }
end
```

## License and Authors

Author:: Joel Scheuner (joel.scheuner.dev@gmail.com)
