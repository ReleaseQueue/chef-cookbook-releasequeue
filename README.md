chef-cookbook-releasequeue Cookbook
====================
This cookbook contains a resource/provider for configuring apt and rpm repositories for your applications defined in Releasequeue so that packages added to your application version should be available for install via apt/yum.


Requirements
------------

#### Cookbooks
- `apt`
- `yum`
- `chef_gem`

#### Platforms
- Debian, Ubuntu
- CentOS, Red Hat, Fedora


Usage
-----

chef_cookbook_releasequeue_application "application_name" do
  version     "version"
  email       "your_email@you.com"
  password    "your_password"
  local_user  "user_name_on_node"
  local_group "group_name_on_node"
  action      :setup
end


Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

