resource_name :instance_image_instance
default_action :create

property :name, String, name_property: true
property :address, String, required: true
property :subnet, String, required: true

config_dir = node['ganeti']['instance_image']['config_dir']

action :create do
  template ::File.join(config_dir, 'networks', 'instances', new_resource.name) do
    cookbook 'ganeti'
    source 'instances.sh.erb'
    variables(
      address: new_resource.address,
      subnet: new_resource.subnet
    )
  end
end

action :delete do
  file ::File.join(config_dir, 'networks', 'instances', new_resource.name) do
    action :delete
  end
end
