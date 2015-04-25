name             'fio'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
license          'Apache 2.0'
description      'Installs and configures the fio benchmark'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

depends 'cwb'
depends 'apt'
depends 'build-essential'

recipe  'fio::default', 'Installs and configures the fio benchmark.'
recipe  'fio::install_source', 'Installs the fio benchmark from source.'
recipe  'fio::install_apt', 'Installs the fio benchmark via apt.'
recipe  'fio::configure', 'Configures the fio benchmark via job file'