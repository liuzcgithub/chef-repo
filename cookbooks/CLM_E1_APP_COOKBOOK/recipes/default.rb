#
# Cookbook Name:: CLM_E1_APP_COOKBOOK
# Recipe:: default
#
# Copyright 2013, IBM
#
# All rights reserved - Do Not Redistribute
#

puts "Inside CLM_E1_APP Cookbook"

#ihs= search (:node, "role:ihs")
#puts "IBM HTTP Server found:" + ihs

remote_directory "/tmp/WASCommon" do
  files_owner "root"
  files_group "root"
  files_mode 00744
  owner "root"
  group "root"
  mode 00755
end

bash "WASCOMMON" do
  cwd Chef::Config['file_cache_path']
  code <<-EOH
  /tmp/WASCommon/WASCommon.sh
  EOH

end

remote_directory "/tmp/Extract_Cert" do
  files_owner "root"
  files_group "root"
  files_mode 00744
  owner "root"
  group "root"
  mode 00755
end

bash "ExtractCert" do
  cwd Chef::Config['file_cache_path']
  code <<-EOH
  /tmp/Extract_Cert/Extract_Cert.sh
  EOH

end

remote_directory "/tmp/Create_WebServer" do
  files_owner "root"
  files_group "root"
  files_mode 00744
  owner "root"
  group "root"
  mode 00755
end

bash "CreateWebServer" do
  cwd Chef::Config['file_cache_path']
  code <<-EOH
  /tmp/Create_WebServer/CreateWebServer.sh
  EOH

end

remote_directory "/tmp/ssea-clm-full-distribute-db2-cfg" do
  files_owner "root"
  files_group "root"
  files_mode 00744
  owner "root"
  group "root"
  mode 00755
end

bash "clmfulldistributedb2cfg" do
  cwd Chef::Config['file_cache_path']
  code <<-EOH
  /tmp/ssea-clm-full-distribute-db2-cfg/config-clm-distributeserver.sh
  EOH

end

