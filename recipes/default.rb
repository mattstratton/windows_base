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

# Set up for DSC

include_recipe 'powershell::powershell5'

powershell "disable RefreshMode" do
  code <<-EOH
  # create a configuration command to generate a meta.mof to set
  # # Local Configuration Manager settings
  Configuration LCMSettings {
    Node localhost {
      LocalConfigurationManager {
        RefreshMode = 'Disabled'
      }
     }
   }
  
  #  Run the configuration command and generate the meta.mof to configure
  # a local configuration manager
  LCMSettings
  
  # Apply the local configuration manager settings found in the LCMSettings
  # folder (by default configurations are generated to a folder in the current
  # working directory named for the configuration command name
  Set-DscLocalConfigurationManager -path ./LCMSettings)
  EOH
end

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
