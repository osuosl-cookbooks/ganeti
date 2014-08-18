#
# Cookbook Name:: ganeti
# Recipe:: default
#
# Copyright (C) 2014 Oregon State University
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
case node['platform_family']
when "rhel"
  include_recipe "yum-epel"
  include_recipe "yum-elrepo"
end

# Ganeti dependencies
include_recipe "lvm"
include_recipe "ganeti::_yum"

packages = node['ganeti']['packages']["#{node['ganeti']['hypervisor']}"] +
  node['ganeti']['packages']['common']

packages.each do |p|
  package p
end

# load/configure drbd/kvm modules
include_recipe "modules"

package node['ganeti']['package_name'] do
  version node['ganeti']['version'] if node['ganeti']['version']
end

service "ganeti" do
  supports status: true, restart: true
  action [:enable, :start]
end

# Disable drbd service, ganeti manages it directly
service "drbd" do
  action [:disable, :stop]
end

cookbook_file "/etc/cron.d/ganeti" do
  source "ganeti-cron"
  owner "root"
  group "root"
  mode "0644"
end

