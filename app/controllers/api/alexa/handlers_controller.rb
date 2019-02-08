class Api::Alexa::HandlersController < ActionController::Base

  include Secured

  def create

    croutine = Api::Alexa.const_get("Alexa#{@alexa_intent_name}")
    intent = croutine.new(request)
    message = intent.handle(request, @current_user)

    render json: message

  end

end
