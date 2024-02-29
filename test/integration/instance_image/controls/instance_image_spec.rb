control 'instance_image' do
  describe package('ganeti-instance-image') do
    it { should be_installed }
  end

  %w(
    /etc/default/ganeti-instance-image
    /etc/ganeti/instance-image/hooks
    /etc/ganeti/instance-image/networks/instances
    /etc/ganeti/instance-image/networks/subnets
  ).each do |f|
    describe file(f) do
      it { should exist }
    end
  end

  describe file '/etc/ganeti/instance-image/variants.list' do
    it { should exist }
    its('content') { should match /default/ }
  end

  options = {
    assignment_regex: /^\s*([^= ]*?)\s?=\s?"(.*?)"\s*$/,
    multiple_values: true,
  }

  describe parse_config_file('/etc/ganeti/instance-image/variants/centos-7.conf', options) do
    its('FILESYSTEM') { should cmp 'ext4' }
    its('IMAGE_NAME') { should cmp 'centos-7.3' }
  end

  describe parse_config_file('/etc/ganeti/instance-image/variants/centos-6.conf', options) do
    its('ARCH') { should cmp 'x86_64' }
    its('BOOT_SIZE') { should cmp '200' }
    its('CACHE_DIR') { should cmp '/var/foo/bar' }
    its('CUSTOMIZE_DIR') { should cmp '/tmp/foo/bar' }
    its('FILESYSTEM') { should cmp 'ext4' }
    its('IMAGE_CLEANUP') { should cmp 'yes' }
    its('IMAGE_DEBUG') { should cmp '1' }
    its('IMAGE_NAME') { should cmp 'centos-6.9' }
    its('IMAGE_TYPE') { should cmp 'tarball' }
    its('IMAGE_URL') { should cmp 'http://ganeti.example.org' }
    its('IMAGE_VERIFY') { should cmp 'no' }
    its('KERNEL_ARGS') { should cmp 'console=ttyS0' }
    its('NOMOUNT') { should cmp 'yes' }
    its('SWAP') { should cmp 'no' }
    its('SWAP_SIZE') { should cmp '1024' }
  end

  describe parse_config_file('/etc/ganeti/instance-image/networks/instances/foo.example.org', options) do
    its('ADDRESS') { should cmp '127.0.0.1' }
    its('SUBNET') { should cmp 'vlan100' }
  end

  describe parse_config_file('/etc/ganeti/instance-image/networks/subnets/vlan100', options) do
    its('NETMASK') { should cmp '255.255.255.0' }
    its('GATEWAY') { should cmp '10.0.0.1' }
  end

  %w(
    /etc/ganeti/instance-image/variants/debian.conf
    /etc/ganeti/instance-image/networks/instances/bar.example.org
    /etc/ganeti/instance-image/networks/subnets/vlan101
  ).each do |d|
    describe file(d) do
      it { should_not exist }
    end
  end

  %w(
    /etc/ganeti/instance-image/hooks/create
    /etc/ganeti/instance-image/hooks/grub
    /etc/ganeti/instance-image/hooks/source
  ).each do |h|
    describe file(h) do
      it { should be_executable }
    end
  end

  %w(
    /etc/ganeti/instance-image/hooks/foo
    /etc/ganeti/instance-image/hooks/disable
  ).each do |h|
    describe file(h) do
      it { should_not be_executable }
    end
  end

  describe file('/etc/ganeti/instance-image/hooks/delete') do
    it { should_not exist }
  end
end
