
# Support whyrun
def whyrun_supported?
  true
end

require "netrc"

action :setup do
  converge_by("Setup apt repo for #{@new_resource.name} #{@new_resource.version}") do

    email = @new_resource.email
    password = @new_resource.password

    rq_conn = RqConn.new(email, password)
    rq_conn.sign_in
    repos = rq_conn.get_app_version_info(@new_resource.name, @new_resource.version)

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

    repos["deb"].each do |deb_repo|
      repo_name = "#{@new_resource.name}_#{deb_repo['distribution']}"

      apt_repository repo_name do
        uri           deb_repo['url']
        components    deb_repo['components']
        distribution  deb_repo["distribution"]
      end
    end
  end
end

