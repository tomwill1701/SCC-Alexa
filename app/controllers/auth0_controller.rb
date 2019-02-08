class Auth0Controller < ApplicationController

  def callback

      auth0_response = request.env['omniauth.auth']

      user = Auth0Authentication.new(auth0_response).run!
      session[:user_id] = user.id

      flash[:notice] = 'Signed in!'
      redirect_to root_path

  end

  def failure
    @error_msg = request.params['message']
  end

end