name             'sysbench-monitored'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures sysbench and cpu monitoring'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

depends 'cwb', '~> 0.1.0'
depends 'apt', '~> 2.7.0'
depends 'sysbench', '~> 1.0.0'

recipe  'sysbench-monitored::default', 'Installs and configures sysbench and cpu monitoring'
recipe  'sysbench-monitored::install', 'Installs sysbench-monitored'
recipe  'sysbench-monitored::configure', 'Configures sysbench-monitored for usage with Cloud WorkBench'
