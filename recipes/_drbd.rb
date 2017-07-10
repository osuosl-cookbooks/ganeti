#
# Cookbook:: ganeti
# Recipe:: _drbd
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
include_recipe 'kernel-modules'
include_recipe 'yum-elrepo' if platform_family?('rhel')

node['ganeti']['packages']['drbd'].each do |drbd_pkg|
  package drbd_pkg
end

# Disable drbd service, ganeti manages it directly
service 'drbd' do
  action [:disable]
end

# TODO: Fix upstream to support Ubuntu/Debian platforms
if node['platform_family'] == 'rhel' # ~FC023
  kernel_module 'drbd' do
    reload true
    force_reload true
    options [
      'minor_count=128',
      'usermode_helper=/bin/true'
    ]
  end
end
