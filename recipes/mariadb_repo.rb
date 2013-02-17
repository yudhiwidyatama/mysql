#
# Cookbook Name:: mysql
# Recipe:: mariadb_repo
#
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

dbversion = "5.5"
platform = node['platform']
case node['platform']
when "ubuntu", "debian"
  include_recipe "apt"
  apt_repository "mariadb" do
    uri "http://mirrors.supportex.net/mariadb/repo/#{dbversion}/#{platform}"
    distribution node['lsb']['codename']
    components ['main']
    keyserver "keys.gnupg.net"
    key "CD2EFD2A"
    action :add
  end
when "centos", "amazon", "redhat"
  include_recipe "yum"
  yum_key "RPM-GPG-KEY-MariaDB" do
    url "https://yum.mariadb.org/RPM-GPG-KEY-MariaDB"
    action :add
  end
  arch = node['kernel']['machine']
  arch = "i386" unless arch == "x86_64"
  pversion = node['platform_version']
  platformcode = "rhel6"
  yum_repository "MariaDB" do
    repo_name "MariaDB"
    description "MariaDB Repo"
    url " http://yum.mariadb.org/#{dbversion}/#{platformcode}-#{arch}/"
    key "RPM-GPG-KEY-percona"
    action :add
  end
end