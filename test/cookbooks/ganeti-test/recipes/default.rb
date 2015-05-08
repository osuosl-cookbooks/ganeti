# XXX: This recipe is only used for testing and should not be used otherwise.
# Setup a fake ganeti cluster ip that's resolvable
hostsfile_entry '192.168.125.10' do
  hostname 'ganeti.local'
  action :create
end
# Make sure the hostname isn't set to localhost
# NOTE: This usually happens on vagrant systems
hostsfile_entry node['network']['interfaces']['eth0']['addresses'].keys[1] do
  hostname node['fqdn']
  aliases [node['hostname']]
  unique true
  action :create
end
