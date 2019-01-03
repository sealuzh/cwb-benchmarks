# Azure

* [vagrant-azure](https://github.com/mitchellh/vagrant-google)
* Virtual Machines: https://azure.microsoft.com/en-us/services/virtual-machines/
* Console: https://portal.azure.com/?whr=live.com#blade/HubsExtension/Resources/resourceType/Microsoft.Compute%2FVirtualMachines
* Vagrant azure: https://github.com/Azure/vagrant-azure
* Create Azure credentials: https://github.com/Azure/vagrant-azure#create-an-azure-active-directory-aad-application

## CWB Configuration

```ruby
'providers' => {
  'azure' => {
    'tenant_id' => 'my_AZURE_TENANT_ID',
    'client_id' => 'my_AZURE_CLIENT_ID',
    'client_secret' => 'my_AZURE_CLIENT_SECRET',
    'subscription_id' => 'my_AZURE_SUBSCRIPTION_ID'
  }
},
```

### Public Key

Next to the private key path `/home/apps/.ssh/cloud-benchmarking.pem`, there MUST exist the matching public key with the name `cloud-benchmarking.pem.pub` according to [source](https://github.com/Azure/vagrant-azure/blob/v2.0/lib/vagrant-azure/action/run_instance.rb#L115).

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

  config.vm.provider :azure do |azure, override|
    # az vm image list --output table
    # az vm image list --output table --publisher Canonical --all
    azure.vm_image_urn = 'Canonical:UbuntuServer:16.04-LTS:latest'
    # az account list-locations
    # Other locations require setting `cwb.azure_id = get_azure_id(execution_id, new_location)`
    azure.location = 'westeurope'
    # az vm list-sizes --location westeurope
    # https://azureprice.net/?region=westeurope
    azure.vm_size = 'Standard_B1s'
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

### Azure Configuration

* VM sizes: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/sizes-general
* Linux VM pricing: https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/
* Image list: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/cli-ps-findimage
* Regions: https://azure.microsoft.com/en-us/regions/
  * CLIv2: `az account list-locations`
