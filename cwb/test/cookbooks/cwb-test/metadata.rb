# Docs: https://docs.chef.io/config_rb_metadata.html
name             'cwb-test'
# maintainer       'YOUR_NAME'
# maintainer_email 'YOUR_EMAIL'
license          'MIT'
description      'Installs/Configures cwb-test'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'cwb', '~> 0.1.0'
depends 'apt', '~> 2.7.0'
