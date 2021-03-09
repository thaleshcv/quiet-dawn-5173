class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :validate_captcha_response, only: :create

  private

  def validate_captcha_response
    return if captcha_disabled? || verify_captcha(params["h-captcha-response"])

    redirect_to new_user_registration_url
  end
end
