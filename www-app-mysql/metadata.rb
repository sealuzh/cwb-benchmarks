name             'www-app-mysql'
maintainer       'seal uzh'
maintainer_email ''
license          'Apache 2.0'
description      'Installs/Configures www-app-mysql'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'apt'
depends 'openssl', '1.1.0'
depends 'build-essential', '2.0.2'
depends 'mysql', '5.2.6'
depends 'database', '2.2.0'
