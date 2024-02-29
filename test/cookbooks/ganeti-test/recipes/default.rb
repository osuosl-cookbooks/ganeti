include_recipe 'openssh'

osl_fakenic 'eth1' do
  ip4 '192.168.125.11/24'
end

append_if_no_line 'ganeti.example.com hostfile entry' do
  path '/etc/hosts'
  line '192.168.125.10 ganeti.example.com'
  sensitive false
end

append_if_no_line 'ganeti interface hostfile entry' do
  path '/etc/hosts'
  line '192.168.125.11 node1.example.com node1'
  sensitive false
  only_if { ::File.readlines('/etc/hosts').grep(/192.168.125.11/).empty? }
end

delete_lines 'remove localhost from hostname' do
  path '/etc/hosts'
  pattern /^(127.0.0.1|::1)\s+node1.*/
  sensitive false
end

ganeti_install 'default' do
  rapi_users(
    testuser1: {
      password: 'p4ssw0rd',
      write: true,
    },
    testuser2: {
      password: 'PASSWORD',
      write: false,
    }
  )
end

ganeti_initialize 'ganeti.example.com' do
  disk_templates %w(diskless)
  master_netdev 'eth1'
  enabled_hypervisors %w(fake)
  nic_mode 'routed'
  nic_link '100'
end

ganeti_service 'default' do
  action :enable
end
