source 'https://supermarket.chef.io'
source 'https://supermarket.osuosl.org'

cookbook 'ganeti-test', path: 'test/cookbooks/ganeti-test'

# Floor only: the yum-elrepo constraint otherwise resolves osl-resources to 1.x.
cookbook 'osl-resources', '>= 2.0'

# TEMPORARY: remove once osl-repos with yum-elrepo >= 3.0.0 is published.
cookbook 'osl-repos', git: 'git@github.com:osuosl-cookbooks/osl-repos.git', branch: 'aokial/upstream-update'

metadata
