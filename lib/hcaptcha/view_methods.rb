module HCaptcha
  module ViewMethods
    def captcha_error
      return unless flash.key?(:captcha_error)

      content_tag(:div, flash[:captcha_error], class: "alert alert-danger")
    end

    def captcha_tag
      content_tag(:div, nil,
        class: "h-captcha",
        data: {
          sitekey: HCaptcha.configuration.sitekey
        })
    end
  end
end
