#
# Cookbook Name:: devops_bootstrap
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Shamelessly stolen from Nordstrom
if node['platform_family'] == 'debian'
  include_recipe "#{cookbook_name}::ubuntu"
elsif node['platform_family'] == 'rhel'
  include_recipe "#{cookbook_name}::centos_rhel"
else
  include_recipe "#{cookbook_name}::#{node['platform_family']}"
end
