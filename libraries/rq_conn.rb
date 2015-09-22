
require "net/https"
require "uri"


class RqConn

  BASE_URL = "https://api.releasequeue.com"

  def initialize(email, password)
    @email = email
    @password = password
  end

  def sign_in()
    uri = URI.parse("#{BASE_URL}/signin")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"email" => @email, "password" => @password})
    response = http.request(request)
    if response.code != "200"
      raise "Error code received from RQ server #{response.code} \n#{response.body}"
    end

    json = JSON.parse(response.body)
    @token = json['token']
    @username = json['username']
  end

  def get_app_version_info(application_name, version)
    uri = URI.parse("#{BASE_URL}/users/#{@username}/applications/#{application_name}/versions/#{version}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request['x-auth-token'] = @token
    response = http.request(request)
    if response.code != "200"
      raise "Error code received from RQ server #{response.code} \n#{response.body}"
    end

    json = JSON.parse(response.body)
    return json["repositories"]
  end

end