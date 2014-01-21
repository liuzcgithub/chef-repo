#
# Cookbook Name:: CLM_E1_DB2_COOKBOOK
# Recipe:: default
#
# Copyright 2013, IBM
#
# All rights reserved - Do Not Redistribute
#
puts "Inside Rational Automation Prep Cookbook"

remote_directory "/tmp/RAT_CreateCLMDB" do
  files_owner "root"
  files_group "root"
  files_mode 00744
  owner "root"
  group "root"
  mode 00755
end

bash "create database" do
  cwd Chef::Config['file_cache_path']
  code <<-EOH
  /tmp/RAT_CreateCLMDB/createDB.sh
  EOH

end

