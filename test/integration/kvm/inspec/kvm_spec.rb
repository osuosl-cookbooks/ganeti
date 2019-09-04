case os[:family].downcase
when 'redhat', 'centos'
  packages = %w(
    qemu-kvm
    qemu-kvm-tools
  )
when 'debian', 'ubuntu'
  packages = %w(
    qemu-kvm
  )
end

packages.each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

# Currently this only works on RHEL systems for now
case os[:family].downcase
when 'redhat', 'centos'
  describe kernel_module('kvm') do
    it { should be_loaded }
  end
end
