class Users::RegistrationsController < Devise::RegistrationsController
  before_action :verify_captcha!, only: :create

  rescue_from "Captcha::VerificationError" do |exception|
    redirect_back fallback_location: new_user_registration_url,
                  allow_other_host: false,
                  alert: "Could not validate the captcha. #{exception.message}."
  end
end
