netdev = if node['platform_version'].to_i < 7
           'eth1'
         else
           'enp0s8'
         end
vg_name = 'ganeti'
vg_file = '/var/tmp/ganeti.img'

node.default['yum']['base']['baseurl'] = 'http://centos.osuosl.org/$releasever/os/$basearch'
node.default['yum']['updates']['baseurl'] = 'http://centos.osuosl.org/$releasever/updates/$basearch/'
node.default['yum']['extras']['baseurl'] = 'http://centos.osuosl.org/$releasever/extras/$basearch/'
node.default['yum']['epel']['baseurl'] = "http://epel.osuosl.org/#{node['platform_version'].to_i}/$basearch"
node.default['ganeti-test']['interface'] = netdev
# node.default['ganeti']['version'] = "2.11.8-2.el#{node['platform_version'].to_i}"
node.default['ganeti']['master-node'] = 'master.localdomain'
node.default['ganeti']['instance_image']['variants_list'] = %w(default cirros)
node.default['ganeti']['instance_image']['config_defaults'] = {
  'arch' => 'x86_64',
  'image_cleanup' => 'no',
  'image_debug' => 1,
  'image_type' => 'qcow2',
  'image_verify' => 'no',
  'nomount' => 'yes',
  'swap' => 'no'
}
node.default['ganeti']['cluster'].tap do |c|
  c['master-netdev'] = netdev
  c['nic'] = {
    'mode' => 'routed',
    'link' => '100'
  }
  c['extra-opts'] = [
    "--vg-name=#{vg_name}",
    '-s 192.168.200.11',
    "-H kvm:kernel_path='',initrd_path=''"
  ].join(' ')
  c['name'] = 'ganeti.localdomain'
end

execute 'Create ganeti volume group' do
  command "dd if=/dev/zero of=#{vg_file} bs=1M seek=20500 count=0;" \
          "vgcreate #{vg_name} $(losetup --show -f #{vg_file})"
  action :run
  not_if "vgs #{vg_name}"
end

hostsfile_entry '127.0.0.1' do
  hostname 'localhost'
  aliases %w(localhost.localdomain localhost4 localhost4.localdomain4)
  action :create
end

hostsfile_entry '192.168.125.10' do
  hostname 'ganeti.localdomain'
  action :create
end

hostsfile_entry '192.168.125.11' do
  hostname 'master.localdomain'
  aliases %w(master)
  action :create
end

hostsfile_entry '192.168.125.12' do
  hostname 'slave.localdomain'
  aliases %w(slave)
  action :create
end

include_recipe 'yum-centos' if platform_family?('rhel')
include_recipe 'ganeti'
include_recipe 'ganeti::instance_image'

instance_image_variant 'cirros' do
  image_name 'cirros-0.3.5'
  image_url 'http://ftp.osuosl.org/pub/osl/ganeti-images/'
end
