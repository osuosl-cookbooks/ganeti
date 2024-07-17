name             'ganeti'
maintainer       'Oregon State University'
maintainer_email 'chef@osuosl.org'
source_url       'https://github.com/osuosl-cookbooks/ganeti'
issues_url       'https://github.com/osuosl-cookbooks/ganeti/issues'
license          'Apache-2.0'
chef_version     '>= 17.0'
description      'Installs/Configures ganeti'
version          '6.0.0'

supports         'almalinux', '~> 8.0'

depends          'selinux'
depends          'yum-elrepo'
depends          'yum-epel'
