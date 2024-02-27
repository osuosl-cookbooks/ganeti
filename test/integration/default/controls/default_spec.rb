rel = os.release.to_i

control 'default' do
  describe yum.repo 'epel' do
    it { should exist }
    it { should be_enabled }
  end

  describe yum.repo 'elrepo' do
    it { should exist }
    it { should be_enabled }
  end

  describe yum.repo 'ganeti' do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should match %r{https://jfut.integ.jp/linux/ganeti/#{rel}/x86_64/?} }
  end

  %w(
    drbd84-utils
    kmod-drbd84
    lvm2
    ganeti
  ).each do |p|
    describe package(p) do
      it { should be_installed }
    end
  end

  describe selinux.booleans.where(name: 'nis_enabled') do
    it { should be_on }
  end

  describe selinux.booleans.where(name: 'domain_can_mmap_files') do
    it { should be_on }
  end

  case rel
  when 7
    %w(qemu-kvm qemu-kvm-tools).each do |p|
      describe package p do
        it { should be_installed }
      end
    end
  when 8
    describe package 'qemu-kvm' do
      it { should be_installed }
    end

    describe selinux.booleans.where(name: 'use_virtualbox') do
      it { should be_on }
    end
  end

  describe kernel_module 'drbd' do
    it { should be_loaded }
  end

  describe file '/sys/module/drbd/parameters/minor_count' do
    its('content') { should cmp "128\n" }
  end

  describe file '/sys/module/drbd/parameters/usermode_helper' do
    its('content') { should cmp "/bin/true\n" }
  end

  describe file '/var/lib/ganeti/rapi' do
    it { should be_directory }
    its('owner') { should cmp 'gnt-rapi' }
    its('group') { should cmp 'gnt-masterd' }
    its('mode') { should cmp '0750' }
  end

  describe file '/var/lib/ganeti/rapi/users' do
    its('owner') { should cmp 'gnt-rapi' }
    its('group') { should cmp 'gnt-masterd' }
    its('mode') { should cmp '0640' }
    its('content') { should match /testuser1 {HA1}076301fd349711d64d87b03ed31c61bc/ }
    its('content') { should match /testuser2 {HA1}7a65e9c1cbc199e849f67783a7c94c0c/ }
  end

  describe file '/etc/lvm/lvmlocal.conf' do
    its('content') { should match %r{filter = \[ "a\|\.\*/\|", "r\|/dev/drbd\[0-9\]\+\|" \]} }
  end

  %w(
    ganeti.target
    ganeti-confd.service
    ganeti-kvmd.service
    ganeti-luxid.service
    ganeti-mond.service
    ganeti-noded.service
    ganeti-rapi.service
    ganeti-wconfd.service
  ).each do |s|
    describe service s do
      it { should be_enabled }
    end
  end

  describe file('/root/.ssh') do
    it { should be_directory }
    its('owner') { should cmp 'root' }
    its('group') { should cmp 'root' }
    its('mode') { should cmp '0700' }
  end

  describe command 'gnt-cluster verify --error-codes' do
    its('exit_status') { should eq 0 }
  end

  describe command 'gnt-cluster info' do
    its('stdout') { should match /Master node: node1.example.com/ }
    its('stdout') { should match /Default hypervisor: fake/ }
    its('stdout') { should match /Enabled hypervisors: fake/ }
    its('stdout') { should match /master netdev: eth1/ }
  end

  describe file('/etc/cron.d/ganeti') do
    it { should exist }
  end

  %w(
    1814
    1811
    1815
    5080
  ).each do |p|
    describe port p do
      it { should be_listening }
    end
  end
end
