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
      return if captcha_disabled? || CaptchaService.new(params["h-captcha-response"]).verify

      redirect_back allow_other_host: false, alert: "Captcha verification failed."
    end
  end
end
