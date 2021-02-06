class Users::SessionsController < Devise::SessionsController
  before_action :verify_captcha!, only: :create

  rescue_from "Captcha::VerificationError" do |exception|
    redirect_back fallback_location: new_user_session_url,
                  allow_other_host: false,
                  alert: "Captcha verification failed. #{exception.message}."
  end
end
