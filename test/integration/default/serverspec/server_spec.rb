require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

case os[:family].downcase
when 'redhat', 'centos'
  packages = [ 'ganeti', 'lvm2', 'qemu-kvm', 'qemu-kvm-tools', 'drbd83-utils',
               'kmod-drbd83' ]
when 'debian', 'ubuntu'
  packages = [ 'ganeti2', 'lvm2', 'qemu-kvm', 'drbd8-utils' ]
end

packages.each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

describe service('ganeti') do
  it { should be_enabled }
end

describe service('drbd') do
  it { should_not be_enabled }
end

describe file('/etc/cron.d/ganeti') do
  it { should be_mode 644 }
  its(:content) {
    should match /45 1 \* \* \* root \[ -x \/usr\/sbin\/ganeti-cleaner \] \&\& \/usr\/sbin\/ganeti-cleaner master/
  }
end

# Currently the drbd module is not included with the kernel installed on the
# Ubuntu/Debian bento boxes, so lets skip those tests for now.
case os[:family].downcase
when 'redhat', 'centos'
  %w[drbd kvm].each do |m|
    describe kernel_module(m) do
      it { should be_loaded }
    end
  end

  # make sure drbd is loaded with the correct module parameters.
  describe file('/sys/module/drbd/parameters/usermode_helper') do
    its(:content) { should match /\/bin\/true/ }
  end

  describe file('/sys/module/drbd/parameters/minor_count') do
    its(:content) { should match /128/ }
  end
end

# Make sure lvm.conf excludes drbd
describe file('/etc/lvm/lvm.conf') do
  its(:content) {
    should match /filter = \[ \"a\/\.\*\/\", \"r\|\/dev\/drbd\.\*\|\" \]/
  }
end

# Test rapi users
describe file('/var/lib/ganeti/rapi/users') do
  it { should_not be_file }
end
