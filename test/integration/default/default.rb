#
# Cookbook Name:: chef-cookbook-releasequeue
# Recipe:: default
#
# Copyright 2015, Releasequeue
#
# All rights reserved - Do Not Redistribute
#

puts "#{node}"

chef_cookbook_releasequeue_application "app1" do
  version "1.0"
  email node['chef-cookbook-releasequeue']['email']
  password node['chef-cookbook-releasequeue']['password']
  local_user node['chef-cookbook-releasequeue']['local_user']
  local_group node['chef-cookbook-releasequeue']['local_group']
  action :setup
end