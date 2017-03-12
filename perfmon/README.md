# perfmon

Installs the PerfMon server agent as a service to be used in combination with JMeter.
See https://jmeter-plugins.org/wiki/PerfMonAgent/

## Attributes

See `attributes/default.rb`

## Usage

### perfmon::default

Add the `perfmon` default recipe to your Chef configuration in the Vagrantfile:

```ruby
config.vm.provision 'cwb', type: 'chef_client' do |chef|
  chef.add_recipe 'perfmon'
  chef.json =
  {
    'perfmon' => {
        # 0 = disabled
        'udp-port' => 0,
        'tcp-port' => 4444,
    },
  }
end
```

## Administration

* Installation directory: `/usr/local/perfmon`

* Start service:

    ```shell
    sudo service perfmon start
    ```

* Stop service:

    ```shell
    sudo service perfmon stop
    ```

* Check logs:

    ```shell
    tail -f /var/log/upstart/perfmon.log
    ```

## License and Authors

Author:: Joel Scheuner (joel.scheuner.dev@gmail.com)
