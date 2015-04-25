# benchmark-name

Installs the benchmark-name benchmark and provides utilities to integrate with Cloud WorkBench.

## Supported Platforms

TODO: list supported platforms here:
=== START EXAMPLE ===
* Ubuntu 14.04 LTS (manually tested)
=== END EXAMPLE ===

## Attributes

See `attributes/default.rb`

## Usage

### Cloud WorkBench

* Create a {ratio/nominal}-scale metric called `METRIC_NAME` which reports results in `UNIT`
* Create a nominal-scale metric called `cpu` which reports the `model name` (OPTIONAL)

### benchmark-name::default

Add the `benchmark-name` default recipe to your Chef configuration in the Vagrantfile:

```ruby
config.vm.provision 'chef_client', id: 'chef_client' do |chef|
  chef.add_recipe 'benchmark-name@0.1.0'  # Version is optional
  chef.json =
  {
    'benchmark-name' => {
        'ATTRIBUTE_1' => 'VALUE_1',
    },
  } # END json
end
```

## License and Authors

Author:: YOUR_NAME (<YOUR_EMAIL>)
