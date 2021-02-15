module HCaptcha
  class Configuration
    DEFAULT_VERIFICATION_URL = "https://hcaptcha.com/siteverify".freeze

    attr_accessor :sitekey, :secret, :url, :skip_envs

    def initialize
      @url = DEFAULT_VERIFICATION_URL
      @skip_envs = %w[development test]
    end
  end
end
