require 'serverspec'

set :backend, :exec

describe package('ganeti-instance-image') do
  it { should be_installed }
end

%w(
  /etc/default/ganeti-instance-image
  /etc/ganeti/instance-image/hooks
  /etc/ganeti/instance-image/variants.list
  /etc/ganeti/instance-image/networks/instances
  /etc/ganeti/instance-image/networks/subnets
).each do |f|
  describe file(f) do
    it { should exist }
  end
end

describe file('/etc/ganeti/instance-image/variants/centos-7.conf') do
  [
    /^FILESYSTEM="ext4"$/,
    /^IMAGE_NAME="centos-7.3"$/,
  ].each do |line|
    its(:content) { should match(line) }
  end
end

describe file('/etc/ganeti/instance-image/variants/centos-6.conf') do
  [
    /^ARCH="x86_64"$/,
    /^BOOT_SIZE="200"$/,
    %r{^CACHE_DIR="/var/foo/bar"$},
    %r{^CUSTOMIZE_DIR="/tmp/foo/bar"$},
    /^FILESYSTEM="ext4"$/,
    /^IMAGE_CLEANUP="yes"$/,
    /^IMAGE_DEBUG="1"$/,
    /^IMAGE_NAME="centos-6.9"$/,
    /^IMAGE_TYPE="tarball"$/,
    %r{^IMAGE_URL="http://ganeti.example.org"$},
    /^IMAGE_VERIFY="no"$/,
    /^KERNEL_ARGS="console=ttyS0"$/,
    /^NOMOUNT="yes"$/,
    /^SWAP="no"$/,
    /^SWAP_SIZE="1024"$/,
  ].each do |line|
    its(:content) { should match(line) }
  end
end

describe file('/etc/ganeti/instance-image/networks/instances/foo.example.org') do
  its(:content) { should match(/^ADDRESS="127.0.0.1"$/) }
  its(:content) { should match(/^SUBNET="vlan100"$/) }
end

describe file('/etc/ganeti/instance-image/networks/subnets/vlan100') do
  its(:content) { should match(/^NETMASK="255.255.255.0"$/) }
  its(:content) { should match(/^GATEWAY="10.0.0.1"$/) }
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
