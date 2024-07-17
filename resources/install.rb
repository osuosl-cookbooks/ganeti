resource_name :ganeti_install
provides :ganeti_install
unified_mode true
default_action :create

property :yum_baseurl, String, default: 'https://jfut.integ.jp/linux/ganeti/$releasever/$basearch'
property :yum_gpgkey, String, default: 'https://jfut.integ.jp/linux/ganeti/RPM-GPG-KEY-integ-ganeti'
property :hypervisor, String, default: 'kvm'
property :kvm_packages, Array, default: lazy { ganeti_kvm_packages }
property :drbd, [true, false], default: true
property :version, String
property :rapi_users, Hash, sensitive: true, default: {}

action :create do
  include_recipe 'yum-epel'

  yum_repository 'ganeti' do
    baseurl new_resource.yum_baseurl
    description 'Integ Ganeti Packages $releasever - $basearch'
    gpgcheck true
    gpgkey new_resource.yum_gpgkey
  end

  selinux_install 'ganeti'

  %w(
    nis_enabled
    domain_can_mmap_files
  ).each do |bool|
    selinux_boolean bool do
      value true
    end
  end

  selinux_boolean 'use_virtualbox' do
    value true
  end

  package 'lvm2'
  package new_resource.kvm_packages if new_resource.hypervisor == 'kvm'

  if new_resource.drbd
    include_recipe 'yum-elrepo'
    package ganeti_drbd_packages

    service 'drbd' do
      action :disable
    end

    kernel_module 'drbd' do
      options [
        'minor_count=128',
        'usermode_helper=/bin/true',
      ]
      action [:install, :load]
    end
  end

  package 'ganeti' do
    version new_resource.version if new_resource.version
  end

  directory '/root/.ssh' do
    mode '700'
    recursive true
  end

  directory '/var/lib/ganeti/rapi' do
    if new_resource.version && Gem::Version.new(new_resource.version) < Gem::Version.new('3.0.0')
      owner 'root'
      group 'root'
    else # ganeti v3+
      owner 'gnt-rapi'
      group 'gnt-masterd'
    end
    mode '0750'
    recursive true
  end

  template '/var/lib/ganeti/rapi/users' do
    if new_resource.version && Gem::Version.new(new_resource.version) < Gem::Version.new('3.0.0')
      owner 'root'
      group 'root'
    else # ganeti v3+
      owner 'gnt-rapi'
      group 'gnt-masterd'
    end
    cookbook 'ganeti'
    source 'users.erb'
    mode '0640'
    sensitive true
    variables(users: rapi_users(new_resource.rapi_users))
  end

  cookbook_file '/etc/lvm/lvmlocal.conf' do
    cookbook 'ganeti'
    source 'lvmlocal.conf'
    mode '0644'
  end
end
