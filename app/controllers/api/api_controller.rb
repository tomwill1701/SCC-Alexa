module Api
  class ApiController < ApplicationController

    skip_before_filter :verify_authenticity_token
    protect_from_forgery with: :null_session
    before_filter :authenticate

    def current_user
      @current_user
    end

    def authenticate
      authenticate_or_request_with_http_basic do |name, password|
        user = User.find_by(name: name)
        if user && user.authenticate(password)
          @current_user = user
          true
        else
          false
        end
      end
    end
  end
end