class ApplicationController < ActionController::Base
  include Pundit
  include CaptchaSupport

  before_action :authenticate_user!
end
