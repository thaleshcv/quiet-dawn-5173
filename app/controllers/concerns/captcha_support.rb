module CaptchaSupport
  extend ActiveSupport::Concern

  included do
    helper_method :captcha_wrapper, :captcha_enabled?, :captcha_disabled?

    def captcha_wrapper
      view_context.content_tag(:div, nil,
        class: "h-captcha",
        data: {
          sitekey: Rails.application.credentials.hcaptcha_sitekey
        })
    end

    def captcha_enabled?
      Rails.application.credentials.hcaptcha_sitekey.present?
    end

    def captcha_disabled?
      !captcha_enabled?
    end

    def verify_captcha!
      return if captcha_disabled?

      captcha_result = Captcha::Verifier.new(params["h-captcha-response"]).perform

      return if captcha_result["success"]

      redirect_back fallback_location: new_user_session_url,
                    allow_other_host: false,
                    alert: "Captcha verification failed. #{captcha_result['error-codes']}"
    end
  end
end
