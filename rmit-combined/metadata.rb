# Docs: https://docs.chef.io/config_rb_metadata.html
name             'rmit-combined'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
source_url       'https://github.com/sealuzh/cwb-benchmarks'
issues_url       'https://github.com/sealuzh/cwb-benchmarks/issues'
license          'MIT'
description      'Installs/Configures `rmit-combined` for cwb'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.4.0'

# CWB
depends 'cwb', '~> 0.1.0'

# External
depends 'apt', '>= 0.0.0'
depends 'build-essential', '>= 0.0.0'

# Internal
depends 'stop-services', '~> 0.1.0'
depends 'wordpress-bench', '~> 2.1.0'
depends 'perfmon', '~> 0.1.0'
