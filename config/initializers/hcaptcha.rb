require "hcaptcha"

HCaptcha.configure do |config|
  config.sitekey = Rails.application.credentials.hcaptcha_sitekey
  config.secret = "0x#{Rails.application.credentials.hcaptcha_secret}"
end
