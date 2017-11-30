name             'ganeti'
maintainer       'Oregon State University'
maintainer_email 'chef@osuosl.org'
source_url       'https://github.com/osuosl-cookbooks/ganeti'
issues_url       'https://github.com/osuosl-cookbooks/ganeti/issues'
license          'Apache 2.0'
description      'Installs/Configures ganeti'
long_description 'Installs/Configures ganeti'
version          '1.4.3'
supports         'ubuntu', '~> 12.04'
supports         'ubuntu', '~> 14.04'
supports         'centos', '~> 6.0'
supports         'centos', '~> 7.0'

depends          'apt'
depends          'kernel-modules'
depends          'lvm'
depends          'yum'
depends          'yum-elrepo'
depends          'yum-epel'
depends          'hostsfile'
