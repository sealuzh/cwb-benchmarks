# Docs: https://docs.chef.io/config_rb_metadata.html
name             'wordpress-bench'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
license          'MIT'
description      'Installs/Configures wordpress-bench'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.1.2'

depends 'cwb', '~> 0.1.0'
depends 'apt', '>= 0.0.0'
depends 'wordpress', '~> 3.2.0'
depends 'build-essential', '>= 0.0.0'

# Is this required on some *nix distributions?
# depends 'libxml2', '~> 0.1.1'
