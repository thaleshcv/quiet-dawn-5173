require "net/http"
require "uri"
require "json"

module Captcha
  # Service Object to validate the hCaptcha response.
  class Verifier
    def initialize(response)
      @response = response
    end

    def perform
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
      raise(VerificationError, response.message) unless response.code == 200

      JSON.parse(response.body)
    end

    def captcha_secret
      "0x#{Rails.application.credentials.hcaptcha_secret}"
    end

    def verify_url
      @verify_url ||= URI.parse("https://hcaptcha.com/siteverify")
    end
  end
end
