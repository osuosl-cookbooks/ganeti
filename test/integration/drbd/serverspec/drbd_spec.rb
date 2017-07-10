require 'serverspec'

set :backend, :exec

case os[:family].downcase
when 'redhat', 'centos'
  case os[:release].to_i
  when 6
    packages = %w(
      drbd83-utils
      kmod-drbd83
    )
  when 7
    packages = %w(
      drbd84-utils
      kmod-drbd84
    )
  end
when 'debian', 'ubuntu'
  packages = %w(
    drbd8-utils
  )
end

packages.each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

describe service('drbd') do
  it { should_not be_enabled }
end

# Currently the drbd module is not included with the kernel installed on the
# Ubuntu/Debian bento boxes, so lets skip those tests for now.
case os[:family].downcase
when 'redhat', 'centos'
  describe kernel_module('drbd') do
    it { should be_loaded }
  end

  # make sure drbd is loaded with the correct module parameters.
  describe file('/sys/module/drbd/parameters/usermode_helper') do
    its(:content) { should match(%r{/bin/true}) }
  end

  describe file('/sys/module/drbd/parameters/minor_count') do
    its(:content) { should match(/128/) }
  end
end
