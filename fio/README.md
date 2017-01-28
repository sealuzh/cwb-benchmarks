# Flexibe I/O Tester (FIO)

Installs and configures the FIO benchmark.

## Supported Platforms

* Ubuntu 14.04 LTS 64 bit (manually tested)


## Dependencies
* apt: used to update the package list which is required (on some systems) to install build-essential
* build-essential: gcc compiler is required for building the benchmark from source

## Attributes

See `attributes/default.rb`

## Usage

### Cloud WorkBench

* Create a ratio-scale metric called `seq. write` which reports the sequential write speed in `KB/s` over time
* Create a nominal-scale metric called `cpu` which reports the `model name`

### FIO Reference

* Freecode: http://freecode.com/projects/fio
* Official website (repo only): http://git.kernel.dk/?p=fio.git;a=summary
* Github: https://github.com/axboe/fio
* 3rd party Wiki: http://www.thomas-krenn.com/en/wiki/Fio.

### fio::default

Vagrant example:

```ruby
config.vm.provision "chef_client" do |chef|
  chef.add_recipe 'fio@1.0.0'  # Version number is optional
  chef.json = {
    'fio' => {
      'version' => '2.1.10',
      'config' => {
        'size' => '100m',
        'refill_buffers' => '1'
      }
    }
  }
  ...
end
```

License and Authors
-------------------
Authors: Joel Scheuner
