# phoronix-test-suite

Installs the `phoronix-test-suite` benchmark and provides utilities to integrate with Cloud WorkBench.

## Attributes

See `attributes/default.rb`

## Usage

### Cloud WorkBench

Metrics depends on what tests and metric names you define.

### phoronix-test-suite::default

Add the `phoronix-test-suite` default recipe to your Chef configuration in the Vagrantfile:

```ruby
config.vm.provision 'chef_client', id: 'chef_client' do |chef|
  chef.add_recipe 'phoronix-test-suite'
  chef.json =
  {
    'phoronix-test-suite' => {
        'tests' => {
            'pts/unpack-linux' => {
                'unpack-linux/avg' => 'Average: ([\d]+.[\d]+) Seconds/',
                'metric2' => 'regex2',
            },
        },
    },
  }
end
```

## License and Authors

Author:: Joel Scheuner (joel.scheuner.dev@gmail.com)
