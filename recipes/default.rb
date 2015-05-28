#
# Cookbook Name:: windows_base
# Recipe:: default
#
# Copyright 2015 Matt Stratton
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

include_recipe 'chef-client::default'
include_recipe 'chef-client::delete_validation'

# Use DSC resource to add some users and groups

dsc_resource "demogroupcreate" do
  resource :group
  property :groupname, 'demo1'
  property :ensure, 'present'
end

dsc_resource "useradd" do
  resource :user
  property :username, "Foobar1"
  property :fullname, "Foobar1"
  property :password, ps_credential("P@assword!")
  property :ensure, 'present'
end

dsc_resource "AddFoobar1ToUsers" do
  resource :Group
  property :GroupName, "demo1"
  property :MembersToInclude, ["Foobar1"]
end
