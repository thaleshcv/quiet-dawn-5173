require "net/http"
require "uri"
require "json"

module Captcha
  # Service Object to validate the hCaptcha response.
  class Verifier
    attr_reader :captcha_response

    def initialize(captcha_response)
      @captcha_response = captcha_response
    end

    def perform
      url = URI("https://hcaptcha.com/siteverify")

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/x-www-form-urlencoded"
      request.body = "secret=#{captcha_secret}&response=#{captcha_response}"

      proccess_response(https.request(request))
    end

    private

    def proccess_response(response)
      raise(VerificationError, response.message) unless response.code == "200"

      JSON.parse(response.body)
    end

    def captcha_secret
      "0x#{Rails.application.credentials.hcaptcha_secret}"
    end
  end
end
