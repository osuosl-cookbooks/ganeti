name             'ganeti'
maintainer       'Oregon State University'
maintainer_email 'chef@osuosl.org'
license          'Apache 2.0'
description      'Installs/Configures ganeti'
long_description 'Installs/Configures ganeti'
version          '0.1.0'
supports         'ubuntu', '~> 12.04'
supports         'centos', '~> 6.0'

depends          'apt'
depends          'lvm'
depends          'modules'
depends          'yum-elrepo'
depends          'yum-epel'
depends          'hostsfile'

supports         'centos', '~> 6'
supports         'ubuntu', '12.04'
supports         'debian', '~> 7'
