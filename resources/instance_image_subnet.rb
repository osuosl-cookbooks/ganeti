resource_name :instance_image_subnet
default_action :create

property :name, String, name_property: true
property :netmask, String, required: true
property :gateway, String, required: true

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
