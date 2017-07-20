default['ganeti']['instance_image']['config_dir'] = '/etc/ganeti/instance-image'
default['ganeti']['instance_image']['variants_list'] = %w(default)
default['ganeti']['instance_image']['yum'] = {
  'description' => 'Ganeti Instance Image - $basearch',
  'url' => 'http://ftp.osuosl.org/pub/osl/ganeti-instance-image/yum/$basearch/$releasever',
  'gpgkey' => 'http://ftp.osuosl.org/pub/osl/ganeti-instance-image/yum/repo.gpg'
}
default['ganeti']['instance_image']['apt'] = {
  'uri' => 'http://ftp.osuosl.org/pub/osl/ganeti-instance-image/apt/',
  'distribution' => node['lsb']['codename'],
  'arch' => 'amd64',
  'components' => %w(main),
  'key' => 'http://ftp.osuosl.org/pub/osl/ganeti-instance-image/apt/repo.gpg'
}
default['ganeti']['instance_image']['config_defaults'] = {}
