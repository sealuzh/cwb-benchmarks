### Installation
# Version of FIO. Only relevant for installation from source code.
# Latest version (2015-04-25): http://git.kernel.dk/?p=fio.git;a=tags
default['fio']['version'] = '2.2.7'
# Install either from source code (source) or via apt (apt).
default['fio']['install_method'] = 'source'
default['fio']['source_url'] = "http://brick.kernel.dk/snaps/fio-#{node['fio']['version']}.tar.gz"

### Benchmark definition
# Ensure that this metric definition exits
default['fio']['metric_definition_id'] = 'seq. write'

### Configuration (format key=value)
# FIO variables available (see section 4.2): http://git.kernel.dk/?p=fio.git;a=blob;f=HOWTO;hb=HEAD
# $pagesize		The architecture page size of the running system
# $mb_memory	Megabytes of total memory in the system
# $ncpus		Number of online available CPUs
# Example usage: size=2*$mb_memory
default['fio']['config']['rw'] = 'write'
default['fio']['config']['size'] = '10m'
default['fio']['config']['bs'] = '4k'
default['fio']['config']['write_bw_log'] = 'fio_write_job' # Generates "fio_write_job_bw.1.log"
default['fio']['config']['direct'] = '1'
default['fio']['config']['ioengine'] = 'sync'
default['fio']['config']['refill_buffers'] = '0'

### FIO config template
default['fio']['template_name'] = 'fio_job.ini.erb'
default['fio']['template_cookbook'] = 'fio'
default['fio']['config_file'] = 'fio_job.ini'

## CLI options
# Example: '--refill_buffers' to prevent SSD compression effect
default['fio']['cli_options'] = ''
