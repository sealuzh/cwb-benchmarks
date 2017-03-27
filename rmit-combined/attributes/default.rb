default['rmit-combined']['repetitions'] = 3

### Installation
# Version of FIO. Only relevant for installation from source code.
# Latest version as of 2017-03-28: 2.18
# Matching the same version as used in the CloudCom2014 paper: https://arxiv.org/pdf/1408.4565.pdf
default['fio']['version'] = '2.1.10'
default['fio']['source_url'] = "http://brick.kernel.dk/snaps/fio-#{node['fio']['version']}.tar.gz"
