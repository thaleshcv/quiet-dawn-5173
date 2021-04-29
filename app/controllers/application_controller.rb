class ApplicationController < ActionController::Base
  include Pundit

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  before_action :authenticate_user!

  def render_404
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || investments_path
  end
end
