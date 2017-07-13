#
# Cookbook:: ganeti
# Recipe:: instance_image
#
# Copyright:: 2017, Oregon State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
include_recipe 'yum' if platform_family?('rhel')
include_recipe 'apt' if platform_family?('debian')
include_recipe 'ganeti'

instance_image = node['ganeti']['instance_image']

yum_repository 'ganeti-instance-image' do
  instance_image['yum'].each do |key, value|
    send(key.to_sym, value)
  end
  only_if { platform_family?('rhel') }
  action :add
end

apt_repository 'ganeti-instance-image' do
  instance_image['apt'].each do |key, value|
    send(key.to_sym, value)
  end
  only_if { platform_family?('debian') }
end

package 'ganeti-instance-image'

[
  ::File.join(instance_image['config_dir'], 'hooks'),
  ::File.join(instance_image['config_dir'], 'variants'),
  ::File.join(instance_image['config_dir'], 'networks', 'instances'),
  ::File.join(instance_image['config_dir'], 'networks', 'subnets')
].each do |d|
  directory d do
    recursive true
  end
end

template '/etc/default/ganeti-instance-image' do
  source 'defaults.sh.erb'
  variables(params: instance_image['config_defaults'])
  action :create
end

template ::File.join(instance_image['config_dir'], 'variants.list') do
  source 'variants.list.erb'
  variables(variants: instance_image['variants_list'])
  action :create
end
