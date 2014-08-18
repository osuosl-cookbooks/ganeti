#
# Cookbook Name:: ganeti
# Recipe:: _yum
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
  yum_repository "ganeti" do
    repositoryid "ganeti"
    description node['ganeti']['yum']['description']
    url node['ganeti']['yum']['uri']
    gpgcheck node['ganeti']['yum']['gpgcheck']
    gpgkey node['ganeti']['yum']['gpgkey']
    action :add
  end
end
