class ApplicationController < ActionController::Base
  include Pundit

  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || investments_path
  end
end
