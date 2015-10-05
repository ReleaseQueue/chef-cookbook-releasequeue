#
# Cookbook Name:: chef-cookbook-releasequeue
# Recipe:: default
#
# Copyright 2015, Releasequeue
#
# All rights reserved - Do Not Redistribute
#

chef_gem 'netrc'

case node['platform_family']
when 'debian'
  apt_package 'lsb-release'
when 'rhel', 'fedora'
  yum_package 'redhat-lsb-core'
end

ohai "reload" do
  action :reload
end
