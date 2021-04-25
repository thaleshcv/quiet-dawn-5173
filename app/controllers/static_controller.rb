class StaticController < ApplicationController
  layout "public"

  skip_before_action :authenticate_user!
  # prepend_before_action :redirect_if_signed_in!

  def landing; end

  private

  def redirect_if_signed_in!
    redirect_to investments_path if user_signed_in?
  end
end
