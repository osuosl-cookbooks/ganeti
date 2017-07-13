resource_name :instance_image_hook
default_action :create

property :name, String, name_property: true
property :enable, [true, false], default: true
property :source, String

config_dir = node['ganeti']['instance_image']['config_dir']

action :enable do
  file ::File.join(config_dir, 'hooks', new_resource.name) do
    mode 0755
    action :touch
  end
end

action :disable do
  file ::File.join(config_dir, 'hooks', new_resource.name) do
    mode 0644
    action :touch
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
