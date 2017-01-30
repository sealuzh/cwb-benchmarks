# stop-services

Utility cookbook that stops all the services listed by the attribute `['stop-services']['stop_list']`.

## Attributes

['stop-services']['stop_list'] list of service names to stop.

## Usage

### stop-services::default

Add the `stop-services` default recipe to your Chef configuration in the Vagrantfile and configure the `stop_list`:

```ruby
config.vm.provision 'cwb', type: 'chef_client' do |chef|
  chef.add_recipe 'stop-services@0.1.0'  # Version is optional
  chef.json =
  {
    'stop-services' => {
        'stop_list' => %w(cron rsyslog atd),
    },
  }
end
```

## License and Authors

Author:: Joel Scheuner (joel.scheuner.dev@gmail.com)
