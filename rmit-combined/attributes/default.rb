# Attributed required in the helper need to be initialized first
default['rmit-combined']['public_ip_query'] = 'wget http://ipecho.net/plain -O - -q'
extend Hostname::Helpers
default['rmit-combined']['public_host'] = guess_public_ip

default['rmit-combined']['repetitions'] = 3
default['rmit-combined']['inter_benchmark_sleep'] = 5 # seconds

# Dynamic attributes
default['rmit-combined']['load_generator'] = '172.31.10.151'
# Setting it here in the attributes makes sure that it is available when
# `cwb` writes the `node.yml` config.
default['wordpress-bench']['load_generator'] = node['rmit-combined']['load_generator']

### Installation
# Version of FIO. Only relevant for installation from source code.
# Latest version as of 2017-03-28: 2.18
# Matching the same version as used in the CloudCom2014 paper: https://arxiv.org/pdf/1408.4565.pdf
default['fio']['version'] = '2.1.10'
default['fio']['source_repo'] = 'http://brick.kernel.dk/snaps/'

# Latest stress-ng version as of 2017-03-28: 0.07.27
default['stressng']['version'] = '0.07.27'
default['stressng']['source_repo'] = 'http://kernel.ubuntu.com/~cking/tarballs/stress-ng/'
