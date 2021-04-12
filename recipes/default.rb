#
# Cookbook:: ganeti
# Recipe:: default
#
# Copyright:: 2015-2021, Oregon State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe 'yum-epel' if platform_family?('rhel')

yum_repository 'ganeti' do
  node['ganeti']['yum'].each do |key, value|
    send(key.to_sym, value)
  end
  only_if { platform_family?('rhel') }
end

apt_repository 'ganeti' do
  node['ganeti']['apt'].each do |key, value|
    send(key.to_sym, value)
  end
  only_if { platform_family?('debian') }
end

include_recipe 'lvm'
include_recipe "ganeti::_#{node['ganeti']['hypervisor']}"
include_recipe 'ganeti::_drbd' if node['ganeti']['drbd']

package node['ganeti']['package_name'] do
  version node['ganeti']['version'] if node['ganeti']['version']
end

# Ensure these directories exist
directory '/root/.ssh' do
  owner 'root'
  group 'root'
  mode '700'
  recursive true
  action :create
end

directory '/var/lib/ganeti/rapi' do
  owner 'root'
  group 'root'
  mode '750'
  recursive true
  action :create
end

# --enabled-disk-templates was added in Ganeti 2.9.0 so let's add logic to deal with that not being available to older
# versions of Ganeti
disk_templates = node['ganeti']['cluster']['disk-templates'].join(',')
enabled_disk_templates =
  if node['ganeti']['version'] && Gem::Version.new(node['ganeti']['version']) >= Gem::Version.new('2.9.0')
    "--enabled-disk-templates=#{disk_templates}"
  # By default, we don't set version so let's assume we can use this option
  elsif node['ganeti']['version'].nil?
    "--enabled-disk-templates=#{disk_templates}"
  end

# Initialize cluster if set as a master-node
execute 'ganeti-initialize' do
  cluster = node['ganeti']['cluster']
  hypervisors = cluster['enabled-hypervisors'].join(',')
  nic_mode = cluster['nic']['mode']
  nic_link = cluster['nic']['link']
  command [
    "#{node['ganeti']['bin-path']}/gnt-cluster init",
    enabled_disk_templates,
    "--master-netdev=#{cluster['master-netdev']}",
    "--enabled-hypervisors=#{hypervisors}",
    "-N mode=#{nic_mode},link=#{nic_link}",
    cluster['extra-opts'], cluster['name']
  ].join(' ')
  creates '/var/lib/ganeti/config.data'
  only_if do
    node['fqdn'] == node['ganeti']['master-node'] ||
      node['ganeti']['master-node'] == true
  end
end

service 'ganeti' do
  service_name 'ganeti.target'
  supports status: true, restart: true
  action [:enable, :start]
end

node['ganeti']['services'].each do |ganeti_service|
  service ganeti_service do
    supports status: true, restart: true
    action :enable
  end
end

cookbook_file '/etc/lvm/lvm.conf' do
  source 'lvm.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

begin
  rapi = data_bag_item('ganeti', node['ganeti']['data_bag']['rapi_users'])

  file '/var/lib/ganeti/rapi/users' do
    owner 'root'
    group 'root'
    mode '640'
    content rapi_users(rapi.to_hash)
  end
rescue
  Chef::Log.info('No rapi_users data bag, skipping')
end
