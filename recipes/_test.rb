#
# Cookbook Name:: ganeti
# Recipe:: _test
#
# Copyright (C) 2015 Oregon State University
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
