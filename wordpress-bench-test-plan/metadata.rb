# Docs: https://docs.chef.io/config_rb_metadata.html
name             'wordpress-bench-test-plan'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
license          'MIT'
description      'Encapsulates a test plan for `wordpress-bench`'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.2'

depends 'cwb', '~> 0.1.0'
depends 'wordpress-bench', '~> 2.0.4'
