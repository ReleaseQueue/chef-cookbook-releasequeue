
# Support whyrun
def whyrun_supported?
  true
end

action :setup do
  require "netrc"

  case node['platform_family']
  when 'debian'
    apt_setup()
  when 'rhel', 'fedora'
    yum_setup()
  end

end

def get_code_name()
  if node["lsb"]["codename"]
    codename = node["lsb"]["codename"]
  else
      case node['platform_family']
      when "rhel", "fedora"
        contents = IO.read("/etc/redhat-release")
        codename = /\((.*)\)/.match(contents).captures[0]
      when "debian"
        contents = IO.read("/etc/os-release")
        codename = /^VERSION=(.*)"$/.match(contents).captures[0]
      end
  end
  if codename
    return codename.gsub(/\s+/, "").downcase()
  else
    return ""
  end
end

def apt_setup()
  converge_by("Setup apt repo for #{@new_resource.name} #{@new_resource.version}") do

    email = @new_resource.email
    password = @new_resource.password

    repos = get_app_versions_from_server

    local_user = @new_resource.local_user
    local_group = @new_resource.local_group
    home = Dir.home(local_user)
    netrc_path = "#{home}/.netrc"
    netrc_data = ::Netrc.read(netrc_path)
    netrc_data['api.releasequeue.com'] = email, password
    netrc_data.save
    FileUtils.chown(local_user,
                    local_group,
                    netrc_path)
    FileUtils.chmod(0600, netrc_path)

    file '/etc/apt/apt.conf.d/00_rq_netrc_creds' do
      content "Dir::Etc::netrc \"#{netrc_path}\";"
      mode '0644'
      owner local_user
      group local_group
    end

    #on some debian setups apt doesnt support https repos by default
    apt_package 'apt-transport-https' do
      action :install
    end

    node_dist_name = get_code_name()

    repos["deb"].each do |deb_repo|
      repo_name = "#{@new_resource.name}"

      dist_name = deb_repo["distribution"].gsub(/\s+/, "").downcase()

      if node_dist_name.include?(dist_name)
        apt_repository repo_name do
          uri           deb_repo['url']
          components    deb_repo['components']
          distribution  deb_repo["distribution"]
        end
      end

    end
  end
end

def yum_setup()
  converge_by("Setup yum repo for #{@new_resource.name} #{@new_resource.version}") do
    require 'cgi'

    repos = get_app_versions_from_server

    name = @new_resource.name
    email = CGI::escape(@new_resource.email)
    password = CGI::escape(@new_resource.password)

    node_dist_name = get_code_name

    repos["rpm"].each do |rpm_repo|
      puts rpm_repo
      dist_name = rpm_repo["distribution"].gsub(/\s+/, "").downcase()

      if node_dist_name.include?(dist_name)
        rpm_repo['components'].each do |component|
          url = "#{rpm_repo['url']}/#{rpm_repo['distribution']}/#{component}"
          url.sub!('https://', "https://#{email}:#{password}@")
          yum_repository name do
            description "Repo for #{name}"
            baseurl url
            action :create
          end
        end
      end

    end
  end
end

def get_app_versions_from_server()
  rq_conn = RqConn.new(@new_resource.email, @new_resource.password)
  rq_conn.sign_in
  rq_conn.get_app_version_info(@new_resource.name, @new_resource.version)
end