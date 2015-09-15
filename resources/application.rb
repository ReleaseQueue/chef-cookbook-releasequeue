
actions :setup
default_action :setup

attribute :name, :kind_of => String, :name_attribute => true, :required => true
attribute :version, :kind_of => String, :required => true
attribute :email, :kind_of => String, :required => true
attribute :password, :kind_of => String, :required => true
attribute :local_user, :kind_of => String, :required => true
attribute :local_group, :kind_of => String, :required => true


