resource_name :ganeti_instance_image
provides :ganeti_instance_image
unified_mode true
default_action :install

property :config_defaults, Hash, default: {}
property :yum_baseurl,
  String,
  default: 'https://ftp.osuosl.org/pub/osl/ganeti-instance-image/yum/$basearch/$releasever'
property :yum_gpgkey, String, default: 'https://ftp.osuosl.org/pub/osl/ganeti-instance-image/yum/repo.gpg'
property :variants_list, Array, default: %w(default)

action :install do
  yum_repository 'ganeti-instance-image' do
    baseurl new_resource.yum_baseurl
    description 'Ganeti Instance Image - $basearch'
    gpgcheck true
    gpgkey new_resource.yum_gpgkey
  end

  package 'ganeti-instance-image'

  [
    ::File.join('/etc/ganeti/instance-image', 'hooks'),
    ::File.join('/etc/ganeti/instance-image', 'variants'),
    ::File.join('/etc/ganeti/instance-image', 'networks', 'instances'),
    ::File.join('/etc/ganeti/instance-image', 'networks', 'subnets'),
  ].each do |d|
    directory d do
      recursive true
    end
  end

  template '/etc/default/ganeti-instance-image' do
    cookbook 'ganeti'
    source 'defaults.sh.erb'
    variables(params: new_resource.config_defaults)
  end

  template '/etc/ganeti/instance-image/variants.list' do
    cookbook 'ganeti'
    source 'variants.list.erb'
    variables(variants: new_resource.variants_list)
  end
end
