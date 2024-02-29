resource_name :ganeti_initialize
provides :ganeti_initialize
unified_mode true
default_action :initialize

property :disk_templates, Array, default: %w(plain drbd)
property :enabled_hypervisors, Array, default: %w(kvm)
property :extra_opts, Array, default: []
property :master_netdev, String, required: true
property :nic_link, String, required: true
property :nic_mode, String, default: 'bridged'

action :initialize do
  execute 'ganeti-initialize' do
    command <<~EOC
      /usr/sbin/gnt-cluster init \
        --enabled-disk-templates #{new_resource.disk_templates.join(',')} \
        --master-netdev=#{new_resource.master_netdev} \
        --enabled-hypervisors=#{new_resource.enabled_hypervisors.join(',')} \
        -N mode=#{new_resource.nic_mode},link=#{new_resource.nic_link} \
        #{new_resource.extra_opts.join(' ')} \
        #{new_resource.name}
    EOC
    creates '/var/lib/ganeti/config.data'
  end
end
