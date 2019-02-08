module Secured
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
  end

  private

  def authenticate_request!
    hash = auth_token
    @current_user = User.find_by(username: hash[0]["sub"])

    if @current_user.nil?
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
    end
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  def http_token
    if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end

  def auth_token

    user = params[:context][:System][:user]
    uid = user[:userId]
    token = user[:accessToken]
    request = params[:request]
    @alexa_request_type = request[:type]
    @alexa_intent_name = request[:intent][:name]

    JsonWebToken.verify(token)
  end

end