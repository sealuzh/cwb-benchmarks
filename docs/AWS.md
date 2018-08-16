# AWS

* [vagrant-aws](https://github.com/mitchellh/vagrant-aws)

## Example CWB Vagrantfile

* Tested 2018-08-16

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

  config.vm.provider :aws do |aws, override|
    aws.region = 'eu-central-1' # Europe/Frankfurt
    # Official Ubuntu 18.04 LTS (hvm:ebs-ssd) image for eu-central-1 from Canonical:
    #  https://cloud-images.ubuntu.com/locator/ec2/
    aws.ami = 'ami-0d9634d5c860a3200'
    # Instance types: https://www.ec2instances.info/
    aws.instance_type = 't2.micro'
    aws.security_groups = ['cwb-web']
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
