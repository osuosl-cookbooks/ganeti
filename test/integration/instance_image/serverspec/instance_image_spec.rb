require 'serverspec'

set :backend, :exec

describe package('ganeti-instance-image') do
  it { should be_installed }
end

%w(
  /etc/default/ganeti-instance-image
  /etc/ganeti/instance-image/variants.list
).each do |f|
  describe file(f) do
    it { should exist }
  end
end

describe file('/etc/ganeti/instance-image/variants/centos-7.conf') do
  [
    /^FILESYSTEM="ext4"$/,
    /^IMAGE_NAME="centos-7.3"$/
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
    /^SWAP_SIZE="1024"$/
  ].each do |line|
    its(:content) { should match(line) }
  end
end

describe file('/etc/ganeti/instance-image/variants/debian.conf') do
  it { should_not exist }
end
