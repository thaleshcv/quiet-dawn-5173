require "net/http"
require "uri"
require "json"

require "hcaptcha/configuration"
require "hcaptcha/controller_methods"
require "hcaptcha/view_methods"

module HCaptcha
  class CaptchaError < StandardError; end
  class VerifyError < StandardError; end

  DEFAULT_ERRORS = {
    captcha_unreachable: "Não conseguimos validar o captcha. Por favor, tente novamente.",
    verification_failed: "Verificação do captcha falhou. Por favor, tente novamente."
  }.freeze

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    cfg = configuration
    yield(cfg)
  end

  def self.skip_env?(env)
    configuration.skip_envs.include?(env)
  end

  def self.perform_verification(response)
    client = Net::HTTP.new(verification_url.host, verification_url.port)
    client.use_ssl = true

    request = Net::HTTP::Post.new(verification_url)
    request["Content-Type"] = "application/x-www-form-urlencoded"
    request.body = "secret=#{configuration.secret}&response=#{response}"

    verification_response = client.request(request)
    raise(VerifyError, response.message) unless verification_response.code == "200"

    JSON.parse(verification_response.body)
  end

  def self.verification_url
    @verification_url ||= URI(configuration.url)
  end

  ActiveSupport.on_load(:action_controller) do
    include(ControllerMethods)
  end

  ActiveSupport.on_load(:action_view) do
    include(ViewMethods)
  end
end
