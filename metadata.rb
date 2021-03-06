name             'chef-cookbook-releasequeue'
maintainer       'Releasequeue'
maintainer_email 'adrian@releasequeue.com'
license          'All rights reserved'
description      'Installs/Configures apt/yum repositories from Releasequeue'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends          'apt', '~> 2.8.2'
depends          'chef_gem', '~> 0.1.0'
depends          'yum'

%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end
