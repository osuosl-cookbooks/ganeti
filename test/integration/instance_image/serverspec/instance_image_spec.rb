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
