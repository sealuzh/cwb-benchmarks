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
    chef.add_recipe 'cli-benchmark' # @x.x.x version is optional
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
