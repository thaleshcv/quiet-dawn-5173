class Users::SessionsController < Devise::SessionsController
  before_action :validate_captcha, only: :create

  private

  def validate_captcha
    unless CaptchaService.new(params["h-captcha-response"]).verify
      redirect_to new_user_session_path, alert: "Captcha verification failed."
    end
  end
end
