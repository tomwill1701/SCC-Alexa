Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
      :auth0,
      ENV['AUTH0_CLIENT_ID'],
      ENV['AUTH0_CLIENT_SEC'],
      ENV['AUTH0_CLIENT_DOM'],
      callback_path: "/auth/auth0/callback",
  authorize_params: {
      scope: 'openid profile'
  }
  )
end