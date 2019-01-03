# AWS

* [vagrant-aws](https://github.com/mitchellh/vagrant-aws)
* EC2: https://aws.amazon.com/ec2/
* Console: https://console.aws.amazon.com/ec2
* Create AWS IAM credentials: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey
  * Create an AWS IAM user (with access key): https://console.aws.amazon.com/iam/home#/users
* Create a AWS security group: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html#CreatingSecurityGroups

## CWB Configuration

```ruby
'providers' => {
  'aws' => {
    'access_key' => 'my_AWS_ACCESS_KEY',
    'secret_key' => 'my_AWS_SECRET_KEY',
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

  config.vm.provider :aws do |aws, override|
    aws.region = 'eu-central-1'
    # Official Ubuntu from Canonical: https://cloud-images.ubuntu.com/locator/ec2/
    # 18.04 LTS hvm:ebs-ssd amd64 eu-central-1
    aws.ami = 'ami-080d06f90eb293a27'
    # https://www.ec2instances.info/
    aws.instance_type = 't2.micro'
    aws.security_groups = ['cwb-web']
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

### AWS Configuration

* [Instance types](https://www.ec2instances.info/)
* Instance pricing: https://aws.amazon.com/ec2/pricing/on-demand/
* Canonical Ubuntu images: https://cloud-images.ubuntu.com/locator/ec2/
  * Release history: https://cloud-images.ubuntu.com/query/trusty/server/released.txt
* Regions: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
