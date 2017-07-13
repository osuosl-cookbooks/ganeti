instance_image_hook 'create'
instance_image_hook 'grub' do
  action :enable
end
instance_image_hook 'foo' do
  action :disable
end
instance_image_hook 'disable' do
  enable false
end
instance_image_hook 'delete' do
  action :delete
end
instance_image_hook 'source' do
  source 'change-source'
end
