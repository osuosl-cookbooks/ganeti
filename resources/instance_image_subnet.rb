resource_name :instance_image_subnet
provides :instance_image_subnet
unified_mode true
default_action :create

property :netmask, String, required: [:create]
property :gateway, String, required: [:create]

config_dir = node['ganeti']['instance_image']['config_dir']

action :create do
  template ::File.join(config_dir, 'networks', 'subnets', new_resource.name) do
    cookbook 'ganeti'
    source 'subnets.sh.erb'
    variables(
      netmask: new_resource.netmask,
      gateway: new_resource.gateway
    )
  end
end

action :delete do
  file ::File.join(config_dir, 'networks', 'subnets', new_resource.name) do
    action :delete
  end
end
