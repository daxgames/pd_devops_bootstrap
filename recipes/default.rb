#
# Cookbook Name:: pd_devops_bootstrap
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Shamelessly stolen from Nordstrom
if node['platform_family'] == 'debian'
  include_recipe "#{cookbook_name}::ubuntu"
elsif node['platform_family'] == 'rhel'
  p "Platform: #{node['platform']}"
  p "Platform Version: #{node['platform_version']}"

  remote_file '/tmp/epel.rpm' do
    source 'https://dl.fedoraproject.org/pub/epel/6/x86_64/Packages/e/epel-release-6-8.noarch.rpm'
    only_if {node['platform'] != 'fedora' && node['platform_version'] =~ /^6/}
  end

  remote_file '/tmp/epel.rpm' do
    source 'https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm'
    only_if {node['platform'] != 'fedora' && node['platform_version'] =~ /^7/}
  end

  yum_package 'epel-release' do
    source '/tmp/epel.rpm'
    only_if {File.exist('/tmp/epel.rpm')}
  end

  # include_recipe "#{cookbook_name}::centos_rhel"
else
  include_recipe "#{cookbook_name}::#{node['platform_family']}"
end
