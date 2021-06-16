case os[:family].downcase
when 'redhat', 'centos'
  packages = %w( ganeti lvm2 )
when 'debian'
  packages = %w( ganeti2 lvm2 )
end

packages.each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

describe service('ganeti') do
  it { should be_enabled }
end

# Make sure lvm.conf excludes drbd
describe file('/etc/lvm/lvm.conf') do
  its('content') do
    should match(%r{filter = \[ "a/.\*/", "r\|/dev/drbd.\*\|" \]})
  end
end

# Test rapi users
describe file('/var/lib/ganeti/rapi/users') do
  it { should_not be_file }
end

describe file('/root/.ssh') do
  it { should be_directory }
  its('owner') { should cmp 'root' }
  its('group') { should cmp 'root' }
  its('mode') { should cmp '0700' }
end

describe file('/var/lib/ganeti/rapi') do
  it { should be_directory }
  its('owner') { should cmp 'gnt-rapi' }
  its('group') { should cmp 'gnt-masterd' }
  its('mode') { should cmp '0750' }
end

describe file('/etc/cron.d/ganeti') do
  it { should exist }
end
