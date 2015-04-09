require 'serverspec'

set :backend, :exec

case os[:family].downcase
when 'redhat', 'centos'
  packages = %w(
    drbd83-utils
    ganeti
    kmod-drbd83
    lvm2
    qemu-kvm
    qemu-kvm-tools
  )
when 'debian', 'ubuntu'
  packages = %w(
    drbd8-utils
    ganeti2
    lvm2
    qemu-kvm
  )
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
  its(:content) do
    should match(%r{45 1 \* \* \* root [ -x /usr/sbin/ganeti-cleaner ] && \
/usr/sbin/ganeti-cleaner master})
  end
end

# Currently the drbd module is not included with the kernel installed on the
# Ubuntu/Debian bento boxes, so lets skip those tests for now.
case os[:family].downcase
when 'redhat', 'centos'
  %w(drbd kvm).each do |m|
    describe kernel_module(m) do
      it { should be_loaded }
    end
  end

  # make sure drbd is loaded with the correct module parameters.
  describe file('/sys/module/drbd/parameters/usermode_helper') do
    its(:content) { should match(%r{/bin/true}) }
  end

  describe file('/sys/module/drbd/parameters/minor_count') do
    its(:content) { should match(/128/) }
  end
end

# Make sure lvm.conf excludes drbd
describe file('/etc/lvm/lvm.conf') do
  its(:content) do
    should match(%r{filter = \[ "a.\*", "r\|/dev/drbd.\*\|" \]})
  end
end

# Test rapi users
describe file('/var/lib/ganeti/rapi/users') do
  it { should_not be_file }
end
