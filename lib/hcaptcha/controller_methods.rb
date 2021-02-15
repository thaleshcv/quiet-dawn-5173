module HCaptcha
  module ControllerMethods
    def self.included(base)
      base.class_eval do
        helper_method :captcha_enabled?, :captcha_disabled?
      end
    end

    private

    def captcha_disabled?
      HCaptcha.skip_env?(Rails.env)
    end

    def captcha_enabled?
      !captcha_disabled?
    end

    def verify_captcha(response)
      return true if captcha_disabled?

      captcha_result = HCaptcha.perform_verification(response)

      return true if captcha_result["success"]

      flash[:captcha_error] = DEFAULT_ERRORS[:verification_failed]
      false
    end

    def verify_captcha!
      verify_captcha || raise(CaptchaError)
    end
  end
end
