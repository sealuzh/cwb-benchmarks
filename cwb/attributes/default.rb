### cwb namespace reserved for parameters passed from cwb-server (and internal use)
# Vagrant does not perform a deep hash merge, therefore we must use a
# reserved namespace to avoid user overwrites. Keep in mind that these
# attributes in the cwb namespace cannot be overridden by users.
default['cwb']['server'] = nil # No useful default value possible
default['cwb']['base_dir'] = '/usr/local/cloud-benchmark'

## Benchmark and BenchmarkSuite list infrastructure
default['cwb']['benchmarks'] = []
# default['cwb']['benchmark_suite'] = nil

### Support legacy benchmarks
default['benchmark']['dir'] = node['cwb']['base_dir']

### Runner that handles nohup and I/O redirection
default['benchmark']['start_runner'] = 'start_runner.sh'
default['benchmark']['stop_and_postprocess_runner'] = 'stop_and_postprocess_runner.sh'

### Execution
# May later change to true if the log files from VMs are considered
default['benchmark']['logging_enabled'] = false
# @deprecated use the more clearer logging_enabled instead
default['benchmark']['redirect_io'] = nil
default['benchmark']['start'] = 'start.sh'
default['benchmark']['stop_and_postprocess'] = 'stop_and_postprocess.sh'

### System specific
# This attribute will overwrite owner and group if present
default['benchmark']['ssh_username'] = nil
default['benchmark']['owner'] = 'ubuntu'
default['benchmark']['group'] = 'ubuntu'


### VM instance identification information
# IMPORTANT: Do not override these attributes manually unless you know what you are doing.
# These values will be dynamically resolved based on the provider config
default['benchmark']['provider_name'] = ''
# Provider instance id used to identify the VM instance from the Cloud-WorkBench
default['benchmark']['provider_instance_id'] = ''


### Supported providers
# Timeout for metadata query requests
default['benchmark']['timeout'] = '2'

# Amazon EC2 Cloud (aws)
default['benchmark']['providers']['aws']['name'] = 'aws'
# Instance id used by Vagrant to identify a VM. Example: 'i-6dd73b2d'
default['benchmark']['providers']['aws']['instance_id_request'] = "wget -q -T #{node['benchmark']['timeout']} -O - http://169.254.169.254/latest/meta-data/instance-id"

# Google Compute Engine (google)
default['benchmark']['providers']['google']['name'] = 'google'
default['benchmark']['providers']['google']['instance_id_request'] = "curl 'http://metadata.google.internal/computeMetadata/v1/instance/attributes/vagrant_id' -H 'Metadata-Flavor: Google' --max-time #{node['benchmark']['timeout']}"

# Microsoft Azure (azure) => EXPERIMENTAL
default['benchmark']['providers']['azure']['name'] = 'azure'
# Exits with success on azure and with non-zero on other providers
azure_detection = 'sudo dmidecode -s system-manufacturer | grep -q "Microsoft Corporation"'
default['benchmark']['providers']['azure']['instance_id_request'] = "echo #{node['cwb']['azure_id']} && dummy=$(#{azure_detection})"

# IBM Softlayer (softlayer) => EXPERIMENTAL
default['benchmark']['providers']['softlayer']['name'] = 'softlayer'
# Exits with success on softlayer and with non-zero on other providers
softlayer_detection = (node['cwb']['provider_name'] == 'softlayer' ? 'echo softlayer-success' : 'exit 1')
default['benchmark']['providers']['softlayer']['instance_id_request'] = "echo #{node['cwb']['softlayer_id']} && dummy=$(#{softlayer_detection})"
