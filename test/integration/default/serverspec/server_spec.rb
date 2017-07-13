require 'serverspec'

set :backend, :exec

case os[:family].downcase
when 'redhat', 'centos'
  case os[:release].to_i
  when 6
    packages = %w(
      ganeti
      lvm2
    )
  when 7
    packages = %w(
      ganeti
      lvm2
    )
  end
when 'debian', 'ubuntu'
  packages = %w(
    ganeti2
    lvm2
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

describe file('/etc/cron.d/ganeti') do
  it { should be_mode 644 }
  its(:content) do
    should match(%r{45 1 \* \* \* root \[ -x /usr/sbin/ganeti-cleaner \] && \
/usr/sbin/ganeti-cleaner master})
  end
end

# Make sure lvm.conf excludes drbd
describe file('/etc/lvm/lvm.conf') do
  its(:content) do
    should match(%r{filter = \[ "a/.\*/", "r\|/dev/drbd.\*\|" \]})
  end
end

# Test rapi users
describe file('/var/lib/ganeti/rapi/users') do
  it { should_not be_file }
end
