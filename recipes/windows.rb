#
# Cookbook Name:: sbp_tcp_offloading
# Recipe:: windows
#
# Copyright 2014, Schuberg Philis
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
#

registry_key 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters' do
  values [{:name => 'EnableRSS', :type => :dword, :data => 0},
          {:name => 'EnableTCPChimney', :type => :dword, :data => 0},
          {:name => 'EnableTCPA', :type => :dword, :data => 0},
          {:name => 'DisableTaskOffload', :type => :dword, :data => 1}]
  action :create
  notifies :run, 'windows_batch[netsh_commands]', :immediately
end

windows_batch "netsh_commands" do
  code <<-EOH
    C:\\Windows\\sysnative\\cmd.exe /c netsh interface tcp set global chimney=disabled
    C:\\Windows\\sysnative\\cmd.exe /c netsh int ip set global taskoffload=disabled
  EOH
  action :nothing
end
