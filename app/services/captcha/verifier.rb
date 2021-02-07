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

      client = create_client(url)
      request = create_request(url, captcha_secret, captcha_response)

      process_response(client.request(request))
    end

    private

    def create_client(url)
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      https
    end

    def create_request(url, secret, response)
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/x-www-form-urlencoded"
      request.body = "secret=#{secret}&response=#{response}"

      request
    end

    def process_response(response)
      raise(VerificationError, response.message) unless response.code == "200"

      JSON.parse(response.body)
    end

    def captcha_secret
      "0x#{Rails.application.credentials.hcaptcha_secret}"
    end
  end
end
