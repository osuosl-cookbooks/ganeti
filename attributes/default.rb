default['ganeti']['version'] = nil
default['ganeti']['hypervisor'] = "kvm"
default['ganeti']['master-node'] = nil
default['ganeti']['bin-path'] = "/usr/sbin"
default['ganeti']['data_bag']['rapi_users'] = "rapi_users"
# Cluster initialization attributes
default['ganeti']['cluster']['extra-opts'] = nil
default['ganeti']['cluster']['disk-templates'] = [ 'plain', 'drbd' ]
default['ganeti']['cluster']['master-netdev'] = "br0"
default['ganeti']['cluster']['enabled-hypervisors'] = [ 'kvm' ]
default['ganeti']['cluster']['nic']['mode'] = "bridged"
default['ganeti']['cluster']['nic']['link'] = "br0"
default['ganeti']['cluster']['name'] = nil

# YUM repo for Ganeti
default['ganeti']['yum']['uri'] = "http://jfut.integ.jp/linux/ganeti/$releasever/$basearch"
default['ganeti']['yum']['description'] = "Integ Ganeti Packages $releasever - $basearch"
default['ganeti']['yum']['gpgcheck'] = false
default['ganeti']['yum']['gpgkey'] = nil
default['modules']['modules']= [
  'drbd minor_count=128 usermode_helper=/bin/true',
  'kvm' ]

default['ganeti']['package_name'] = value_for_platform_family(
  {
    "rhel" => "ganeti",
    "debian" => "ganeti2"
  }
)
default['ganeti']['packages']['kvm'] = value_for_platform_family(
  {
    "rhel" => ['qemu-kvm', 'qemu-kvm-tools'],
    "debian" => ['qemu-kvm']
  }
)
default['ganeti']['packages']['common'] = value_for_platform_family(
  {
    "rhel" => ['drbd83-utils', 'kmod-drbd83'],
    "debian" => ['drbd8-utils'],
  }
)
