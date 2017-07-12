# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = ENV['GANETI_OS'] || 'bento/centos-7.3'
  [
    %w(master 11),
    %w(slave 12)
  ].each do |name, ip_suff|
    config.vm.define name do |node|
      node.vm.network :private_network, ip: "192.168.125.#{ip_suff}"
      node.vm.network :private_network, ip: "192.168.200.#{ip_suff}"
      node.vm.hostname = "#{name}.localdomain"
      node.vm.provision 'chef_solo' do |chef|
        chef.version = '12.18.31'
        chef.cookbooks_path = 'cookbooks'
        chef.data_bags_path = 'test/integration/data_bags'
        chef.encrypted_data_bag_secret_key_path = 'test/integration/encrypted_data_bag_secret'
        chef.nodes_path = 'nodes'
        chef.roles_path = 'test/integration/roles'
        chef.add_role("ganeti_#{name}")
      end
    end
  end
end
