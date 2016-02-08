
require "net/https"
require "uri"


class RqConn

  BASE_URL = "https://api.releasequeue.com"
  SERVER_PORT = 443

  def initialize(username, api_key)
    @username = username
    @api_key = api_key
  end

  def get_app_version_info(application_name, version)
    uri = URI.parse("#{BASE_URL}/users/#{@username}/applications/#{application_name}/versions/#{version}")
    http = Net::HTTP.new(uri.host, SERVER_PORT)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request["Authorization"] = "Bearer #{@api_key}"
    response = http.request(request)
    if response.code != "200"
      raise "Error code received from RQ server #{response.code} \n#{response.body}"
    end

    json = JSON.parse(response.body)
    return json["repositories"]
  end

end