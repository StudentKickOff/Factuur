class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  http_basic_authenticate_with name: Rails.application.secrets.auth_username,
    password: Rails.application.secrets.auth_password
end
