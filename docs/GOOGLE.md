# Google

* [vagrant-google](https://github.com/mitchellh/vagrant-google)

## CWB Configuration

```ruby
'providers' => {
  'google' => {
      'project_id' => 'my_GOOGLE_PROJECT_ID',
      'client_email' => 'my_GOOGLE_CLIENT_EMAIL',
      'json_key_FILE' => File.read('my_GOOGLE_JSON_KEY_PATH'),
  },
},
```

## Example CWB Vagrantfile

* Tested 2019-01-03
* Source: https://github.com/sealuzh/cloud-workbench/blob/master/lib/templates/erb/Vagrantfile_example.erb

```ruby
# The following variables are available
# benchmark_name: Name of the benchmark definition from the web interface
# benchmark_name_sanitized: benchmark_name where all non-word-characters are replaced with an underscore '_'
# benchmark_id: The unique benchmark definition identifier
# execution_id: The unique benchmark execution identifier
# chef_node_name: The default node name used for Chef client provisioning
# tag_name: The default tag name set as aws name tag

SSH_USERNAME = 'ubuntu'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.username = SSH_USERNAME

  config.vm.provider :google do |google, override|
    # https://cloud.google.com/compute/docs/images
    google.image = 'ubuntu-1604-xenial-v20181204'
    # https://cloud.google.com/compute/docs/machine-types
    google.machine_type = 'f1-micro' # Default: 'n1-standard-1'
    # https://cloud.google.com/compute/docs/regions-zones/
    google.zone = 'europe-west3-b'
  end

  config.vm.provision 'cwb', type: 'chef_client' do |chef|
    chef.add_recipe 'cli-benchmark' # @1.1.0 version is optional
    chef.json =
    {
      'benchmark' =>  {
          'ssh_username' => SSH_USERNAME,
      },
      'cli-benchmark' => {
          'packages' => %w(sysbench),
          # 'install' => 'cd /usr/local && echo "This runs during installation." >> install.txt',
          # 'pre_run' => 'echo "This runs immediately before execution" >> log.txt',
          'run' => 'sysbench --test=cpu --cpu-max-prime=4000 run',
          'repetitions' => 3,
          'metrics' => {
            # [name of the metric] => [regex to extract result from stdout],
            'execution_time' => 'total time:\s*(\d+\.\d+)s',
          },
      },
    }
  end
end
```
