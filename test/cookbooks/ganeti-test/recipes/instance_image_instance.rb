instance_image_instance 'foo.example.org' do
  address '127.0.0.1'
  subnet 'vlan100'
end

instance_image_instance 'bar.example.org' do
  address ''
  subnet ''
  action :delete
end
