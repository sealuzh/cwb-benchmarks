# iperf

Installs and configures the iperf client

## Supported Platforms

Should work for Ubuntu and Debian.

* Ubuntu 14.04 (manually tested)

## Attributes

See `attributes/default.rb`

## Usage

### Cloud WorkBench

* Create a nominal-scale metric called `bandwidth` which reports results in `bandwidth per second`

### iperf Reference

* man page: http://manpages.ubuntu.com/manpages/precise/en/man1/iperf.1.html
* Getting started tutorial: http://openmaniak.com/iperf.php

### iperf::client

Add the `iperf` client recipe to your Chef configuration:

```ruby
config.vm.provision 'chef_client' do |chef|
  chef.add_recipe 'iperf::client@1.0.0'  # Version is optional
  chef.json =
  {
    'iperf' => {
        # Make sure you assign `chef.node_name =` to the server
        'server_node_name' => "#{chef_node_name}-iperf-server",
        'time' => 20,
    }
  }
end
```

## License and Authors

Author:: Joel Scheuner (joel.scheuner.dev@gmail.com)