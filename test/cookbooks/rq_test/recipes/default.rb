#
# Cookbook Name:: rq_test
# Recipe:: default
#
# Copyright 2015, Releasequeue
#
# All rights reserved - Do Not Redistribute
#
require 'json'

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

file = Chef::Util::FileEdit.new("/etc/hosts")
file.insert_line_if_no_match("/releasequeue.com/", "#{rq_ip} releasequeue.com")
file.insert_line_if_no_match("/api.releasequeue.com/", "#{rq_ip} api.releasequeue.com")
file.write_file


case node['platform']
when 'debian'
  cookbook_file "/usr/local/share/ca-certificates/my_cert.crt" do
    source "cert.crt"
    owner "root"
    group "root"
    mode 00600
    action :create_if_missing
  end
  execute "sudo update-ca-certificates"
  execute "sudo dpkg-reconfigure ca-certificates -f noninteractive"
when 'rhel', 'fedora', 'centos'
  cookbook_file "/etc/pki/ca-trust/source/anchors/my_cert.crt" do
    source "cert.crt"
    owner "root"
    group "root"
    mode 00600
    action :create_if_missing
  end
  execute "update-ca-trust enable"
  execute "update-ca-trust extract"
end


chef_cookbook_releasequeue_application "app1" do
  version     "1.0"
  email       params['rq_test']['email']
  password    params['rq_test']['password']
  local_user  params['rq_test']['local_user']
  local_group params['rq_test']['local_group']
  action      :setup
end