# XXX: This recipe is only used for testing and should not be used otherwise.
# Setup a fake ganeti cluster ip that's resolvable
include_recipe 'openssh'

append_if_no_line 'ganeti.local hostfile entry' do
  path '/etc/hosts'
  line '192.168.125.10 ganeti.local'
end

host = node['fqdn'].nil? ? node['hostname'] : node['fqdn']
ip = node['network']['interfaces'][node['ganeti-test']['interface']]['addresses'].keys[1]

append_if_no_line 'ganeti interface hostfile entry' do
  path '/etc/hosts'
  line "#{host} #{ip}"
end
