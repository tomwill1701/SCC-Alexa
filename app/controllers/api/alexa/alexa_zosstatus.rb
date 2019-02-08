class Api::Alexa::AlexaZosstatus < Ralyxa::Handler

  def handle(request, current_user)

    message = "hello from D T S, S C C, for #{current_user.name}"
    respond(message)

  end

end