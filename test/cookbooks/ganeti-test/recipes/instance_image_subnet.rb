instance_image_subnet 'vlan100' do
  netmask '255.255.255.0'
  gateway '10.0.0.1'
end

instance_image_subnet 'vlan101' do
  netmask ''
  gateway ''
  action :delete
end
