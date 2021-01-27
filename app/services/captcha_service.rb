require "net/http"
require "uri"
require "json"

# Service Object to validate the hCaptcha response.
class CaptchaService
  def initialize(response)
    @response = response
  end

  def verify
    header = { 'Content-Type': "application/x-www-form-urlencoded" }
    data = {
      response: @response,
      secret: captcha_secret
    }

    http = Net::HTTP.new(verify_url.host, verify_url.port)
    request = Net::HTTP::Post.new(verify_url.request_uri, header)
    request.body = data.to_json

    proccess_response(http.request(request))
  end

  private

  def proccess_response(response)
    # need error handling
    return false unless response.code == 200

    response = JSON.parse(response.body)
    response["success"]
  end

  def captcha_secret
    "0x#{Rails.application.credentials.hcaptcha_secret}"
  end

  def verify_url
    @verify_url ||= URI.parse("https://hcaptcha.com/siteverify")
  end
end
