require 'serverspec'

describe file('/etc/yum.repos.d/app1_dist1.repo'), :if => os[:family] == 'redhat' do
  its(:content) { should match /api.releasequeue.com\/users\/admin\/applications\/app1\/1.0\/rpm\/dist1\/comp1/ }
end

describe file('/etc/apt/sources.list.d/app1_dist1.list'), :if => os[:family] == 'ubuntu' do
  its(:content) { should match /http:\/\/api.releasequeue.com\/users\/admin\/applications\/app1\/1.0\/deb/ }
end

