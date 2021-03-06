name             'ganeti'
maintainer       'Oregon State University'
maintainer_email 'chef@osuosl.org'
source_url       'https://github.com/osuosl-cookbooks/ganeti'
issues_url       'https://github.com/osuosl-cookbooks/ganeti/issues'
license          'Apache-2.0'
chef_version     '>= 16.0'
description      'Installs/Configures ganeti'
version          '5.0.0'

supports         'centos', '~> 7.0'

depends          'yum-elrepo'
depends          'yum-epel'
