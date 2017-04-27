# Docs: https://docs.chef.io/config_rb_metadata.html
name             'perfmon'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
license          'MIT'
description      'Installs the PerfMon server agent as a service'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

depends 'apt', '>= 0.0.0'
depends 'ark', '~> 2.2.1'
depends 'poise-service', '~> 1.4.2'
