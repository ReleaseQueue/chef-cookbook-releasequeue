#
# Cookbook Name:: rq_test
# Recipe:: default
#
# Copyright 2015, Releasequeue
#
# All rights reserved - Do Not Redistribute
#
require 'json'
include_recipe 'apt'


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

params = JSON.parse(IO.read("/tmp/kitchen/dna.json"))

rq_ip = params['rq_test']['rq_ip']


chef_cookbook_releasequeue_application "app1" do
  version     "1.0"
  username    params['rq_test']['username']
  api_key     params['rq_test']['api_key']
  local_user  params['rq_test']['local_user']
  local_group params['rq_test']['local_group']
  action      :setup
end