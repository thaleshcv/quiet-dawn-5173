class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :validate_captcha_response, only: :create
  before_action :configure_permitted_parameters

  private

  def validate_captcha_response
    return if captcha_disabled? || verify_captcha(params["h-captcha-response"])

    redirect_to new_user_registration_url
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:avatar, :name, :email, :password, :password_confirmation, :current_password)
    end
  end
end
