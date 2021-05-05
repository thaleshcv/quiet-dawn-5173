class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :validate_captcha_response, only: :create

  before_action :validate_edit_section, only: :edit
  before_action :configure_permitted_parameters

  helper_method :current_section

  EDIT_ACCOUNT_SECTIONS = %w[profile password settings].freeze

  def update
    # Copied the entire original implementation since we need a different
    # response on failure but that's not customizable.
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      after_update_resource(resource, prev_unconfirmed_email)
      # fixed the location
      respond_with resource, location: edit_user_registration_path
    else
      clean_up_passwords resource
      set_minimum_password_length

      # this is what we need
      render :edit, section: current_section
    end
  end

  private

  def after_update_resource(resource, prev_unconfirmed_email)
    set_flash_message_for_update(resource, prev_unconfirmed_email)
    if sign_in_after_change_password?
      bypass_sign_in resource, scope: resource_name
    else
      sign_in(resource_name, resource)
    end
  end

  def validate_edit_section
    raise(ActionController::RoutingError, "Not Found") unless EDIT_ACCOUNT_SECTIONS.include?(current_section)
  end

  def current_section
    params.fetch(:section, "profile")
  end

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
