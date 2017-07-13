default['ganeti']['version'] = nil
default['ganeti']['hypervisor'] = 'kvm'
default['ganeti']['drbd'] = true
default['ganeti']['master-node'] = nil
default['ganeti']['bin-path'] = '/usr/sbin'
default['ganeti']['data_bag']['rapi_users'] = 'rapi_users'
default['modules']['modules'] = [
  'drbd minor_count=128 usermode_helper=/bin/true',
  'kvm'
]
# Cluster initialization attributes
default['ganeti']['cluster']['name'] = nil
default['ganeti']['cluster']['disk-templates'] = %w(plain drbd)
default['ganeti']['cluster']['master-netdev'] = 'br0'
default['ganeti']['cluster']['enabled-hypervisors'] = ['kvm']
default['ganeti']['cluster']['nic']['mode'] = 'bridged'
default['ganeti']['cluster']['nic']['link'] = 'br0'
default['ganeti']['cluster']['extra-opts'] = nil

# YUM repo for Ganeti
default['ganeti']['yum']['url'] = 'http://jfut.integ.jp/linux/ganeti/$releasever/$basearch'
default['ganeti']['yum']['description'] = 'Integ Ganeti Packages $releasever - $basearch'
default['ganeti']['yum']['gpgcheck'] = false
default['ganeti']['yum']['gpgkey'] = nil

# APT repo for Ganeti on Ubuntu
default['ganeti']['apt']['uri'] = 'ppa:pkg-ganeti-devel/lts'
default['ganeti']['apt']['distribution'] = node['lsb']['codename']
default['ganeti']['apt']['components'] = %w(main)
default['ganeti']['apt']['keyserver'] = 'keyserver.ubuntu.com'
default['ganeti']['apt']['key'] = '38520275'

default['ganeti']['package_name'] =
  case node['platform_family']
  when 'rhel'
    'ganeti'
  when 'debian'
    'ganeti2'
  end
default['ganeti']['packages']['kvm'] =
  case node['platform_family']
  when 'rhel'
    %w(qemu-kvm qemu-kvm-tools)
  when 'debian'
    %w(qemu-kvm)
  end
default['ganeti']['packages']['drbd'] =
  case node['platform_family']
  when 'rhel'
    if node['platform_version'].to_i < 7
      %w(drbd83-utils kmod-drbd83)
    else
      %w(drbd84-utils kmod-drbd84)
    end
  when 'debian'
    %w(drbd8-utils)
  end
