class Users::SessionsController < Devise::SessionsController
  before_action :verify_captcha!, only: :create
end
