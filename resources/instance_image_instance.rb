resource_name :instance_image_instance
provides :instance_image_instance
unified_mode true
default_action :create

property :address, String, required: [:create]
property :subnet, String, required: [:create]

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
