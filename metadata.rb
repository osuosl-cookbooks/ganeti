name             'ganeti'
maintainer       'Oregon State University'
maintainer_email 'chef@osuosl.org'
source_url       'https://github.com/osuosl-cookbooks/ganeti'
issues_url       'https://github.com/osuosl-cookbooks/ganeti/issues'
license          'Apache-2.0'
chef_version     '>= 14.0'
description      'Installs/Configures ganeti'
version          '2.3.1'

supports         'centos', '~> 7.0'

depends          'lvm'
depends          'yum-elrepo'
depends          'yum-epel'
depends          'hostsfile'
