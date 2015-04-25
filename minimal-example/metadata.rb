# Docs: https://docs.chef.io/config_rb_metadata.html
name             'minimal-example'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
license          'MIT'
description      'Installs/Configures minimal-example'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'cwb', '~> 0.1.0'
depends 'apt', '~> 2.7.0'

