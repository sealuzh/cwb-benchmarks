# Docs: https://docs.chef.io/config_rb_metadata.html
name             'molecular-dynamics-simulation'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
license          'MIT'
description      'Installs/Configures molecular-dynamics-simulation'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'cwb', '~> 0.1.3'
depends 'apt', '~> 5.0.1'
depends 'build-essential', '~> 7.0.3'
