resource_name :instance_image_hook
provides :instance_image_hook
unified_mode true
default_action :create

property :enable, [true, false], default: true
property :source, String

config_dir = node['ganeti']['instance_image']['config_dir']

action :enable do
  file ::File.join(config_dir, 'hooks', new_resource.name) do
    mode '755'
  end
end

action :disable do
  file ::File.join(config_dir, 'hooks', new_resource.name) do
    mode '644'
  end
end

action :create do
  cookbook_file ::File.join(config_dir, 'hooks', new_resource.name) do
    source new_resource.source || new_resource.name
  end
  run_action :enable if new_resource.enable
  run_action :disable unless new_resource.enable
end

action :delete do
  file ::File.join(config_dir, 'hooks', new_resource.name) do
    action :delete
  end
end
