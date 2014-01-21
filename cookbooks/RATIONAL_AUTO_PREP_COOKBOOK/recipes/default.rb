#
# Cookbook Name:: RATIONAL_AUTO_PREP_COOKBOOK
# Recipe:: default
#
# Copyright 2013, IBM
#
# All rights reserved - Do Not Redistribute
#
puts "Inside Rational Automation Prep Cookbook"

remote_directory "/tmp/AutomationPrep" do
  files_owner "root"
  files_group "root"
  files_mode 00744
  owner "root"
  group "root"
  mode 00755
end

bash "run Automation Prep" do
  cwd Chef::Config['file_cache_path'] 
  code <<-EOH
  /tmp/AutomationPrep/CoreAutomationPrep.sh
  EOH

end
