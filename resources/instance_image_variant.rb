resource_name :instance_image_variant
default_action :create

property :name, String, name_property: true
property :arch, String, default: ''
property :boot_size, String, default: ''
property :cache_dir, String, default: ''
property :cdinstall, String, default: ''
property :customize_dir, String, default: ''
property :filesystem, String, default: ''
property :image_cleanup, String, default: ''
property :image_debug, String, default: ''
property :image_dir, String, default: ''
property :image_name, String, required: true
property :image_type, String, default: ''
property :image_url, String, default: ''
property :image_verify, String, default: ''
property :kernel_args, String, default: ''
property :nomount, String, default: ''
property :overlay, String, default: ''
property :swap, String, default: ''
property :swap_size, String, default: ''

config_dir = node['ganeti']['instance_image']['config_dir']

action :create do
  template ::File.join(config_dir, 'variants', "#{new_resource.name}.conf") do
    cookbook 'ganeti'
    source 'variants.sh.erb'
    variables(
      arch: new_resource.arch,
      boot_size: new_resource.boot_size,
      cache_dir: new_resource.cache_dir,
      cdinstall: new_resource.cdinstall,
      customize_dir: new_resource.customize_dir,
      filesystem: new_resource.filesystem,
      image_cleanup: new_resource.image_cleanup,
      image_debug: new_resource.image_debug,
      image_dir: new_resource.image_dir,
      image_name: new_resource.image_name,
      image_type: new_resource.image_type,
      image_url: new_resource.image_url,
      image_verify: new_resource.image_verify,
      kernel_args: new_resource.kernel_args,
      nomount: new_resource.nomount,
      overlay: new_resource.overlay,
      swap: new_resource.swap,
      swap_size: new_resource.swap_size
    )
  end
end

action :delete do
  file ::File.join(config_dir, 'variants', "#{new_resource.name}.conf") do
    action :delete
  end
end
