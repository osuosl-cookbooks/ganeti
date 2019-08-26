require 'open3'

case os[:family].downcase
when 'redhat', 'centos'
  cleaner_user = 'root'
  case os[:release].to_i
  when 6
    packages = %w(
      drbd83-utils
      ganeti
      kmod-drbd83
      lvm2
      qemu-kvm
      qemu-kvm-tools
    )
    services = %w(ganeti)
  when 7
    packages = %w(
      drbd84-utils
      ganeti
      kmod-drbd84
      lvm2
      qemu-kvm
      qemu-kvm-tools
    )
    services = %w(
      ganeti
      ganeti-confd
      ganeti-kvmd
      ganeti-luxid
      ganeti-noded
      ganeti-rapi
      ganeti-wconfd
    )
  end
when 'debian'
  packages = %w(
    drbd8-utils
    ganeti2
    lvm2
    qemu-kvm
  )
  cleaner_user = 'gnt-masterd'
  services = %w(ganeti)
end

packages.each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

services.each do |s|
  describe service(s) do
    it { should be_enabled }
  end
end

describe service('drbd') do
  it { should_not be_enabled }
end

describe crontab(path: '/etc/cron.d/ganeti').where {
  command =~ %r{\[ -x /usr/sbin/ganeti-cleaner \] && /usr/sbin/ganeti-cleaner master}
} do
  its('user') { should include cleaner_user }
  its('minutes') { should cmp '45' }
  its('hours') { should cmp '1' }
  its('days') { should cmp '*' }
  its('weekdays') { should cmp '*' }
  its('months') { should cmp '*' }
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
    its('content') { should match(%r{/bin/true}) }
  end

  describe file('/sys/module/drbd/parameters/minor_count') do
    its('content') { should match(/128/) }
  end
end

# Make sure lvm.conf excludes drbd
describe file('/etc/lvm/lvm.conf') do
  its('content') do
    should match(%r{filter = \[ "a/.\*/", "r\|/dev/drbd.\*\|" \]})
  end
end

# Test rapi users
describe file('/var/lib/ganeti/rapi/users') do
  its('mode') { should cmp '0640' }
  its('content') { should include 'testuser1 {HA1}b2a16f011884b8d59df9e7be4e2f3ae8 write' }
  its('content') { should include 'testuser2 {HA1}35806ebfe30a5c127194161a88d2b796' }
end

# testuser1 {HA1}b2a16f011884b8d59df9e7be4e2f3ae8 write
# testuser2 {HA1}35806ebfe30a5c127194161a88d2b796

# Test ganeti processes
ganeti_version = inspec.command("ganeti-noded --version | awk '{print $3}'").stdout.chomp
ganeti_services = if Gem::Version.new(ganeti_version) < Gem::Version.new('2.12.0')
                    %w(noded masterd rapi luxid confd)
                  # mond is excluded on CentOS 7 for whatever reason
                  elsif os[:release].to_i == 7 && os[:family] == 'redhat'
                    %w(noded wconfd rapi luxid)
                  else
                    %w(noded wconfd rapi luxid mond)
                  end

ganeti_services.each do |d|
  describe service("ganeti-#{d}") do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end

# Test ganeti ports
%w(1811 5080).each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

# Verify ganeti
describe command('/usr/sbin/gnt-cluster verify') do
  its('exit_status') { should eq 0 }
end
