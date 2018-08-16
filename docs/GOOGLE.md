# Google

* [vagrant-google](https://github.com/mitchellh/vagrant-google)

## Example CWB Vagrantfile

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
    # https://console.cloud.google.com/compute/images
    google.image = 'ubuntu-1604-xenial-v20170619a'
    # https://cloud.google.com/compute/docs/machine-types
    google.machine_type = 'n1-standard-1'
    # https://cloud.google.com/compute/docs/regions-zones/regions-zones
    google.zone = 'europe-west1-b'
  end

  config.vm.provision 'cwb', type: 'chef_client' do |chef|
    chef.add_recipe 'cli-benchmark@1.0.2'  # Version is optional
    chef.json =
    {
      'benchmark' =>  {
          'ssh_username' => SSH_USERNAME,
      },
      'cli-benchmark' => {
          'packages' => %w(sysbench),
          # Strive for idempotency here (i.e., multiple executions shouldn't fail)
        # 'install' => 'cd /usr/local && echo "This runs during installation." > install.txt',
        # 'pre_run' => 'echo "This runs immediately before execution" > pre_run.txt',
          'run' => 'sysbench --test=cpu --cpu-max-prime=4000 run',
          'metrics' => {
            # [name of the metric] => [regex to extract result from stdout],
            'execution_time' => 'total time:\s*(\d+\.\d+)s',
          },
      },
    }
  end
end
```
