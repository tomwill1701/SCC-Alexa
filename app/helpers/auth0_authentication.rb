class Auth0Authentication

  def initialize(auth)
    @auth = auth
    @info = @auth[:info]
    @raw = @auth[:extra][:raw_info]
    @metadata = @raw[:user_metadata] if @raw[:user_metadata]
    @identities = @raw[:identities] if @raw[:identities]
    @name = @info[:name]
    @uid = @auth[:uid]
  end

  def run!

    email = @info[:email]|| @raw[:email]
    user = User.find_by(username: @uid)

    if user.nil?
      user = User.new(username: @uid) do |user|
        user.name       = @name
        user.email      = email
        user.password   = "auth0"
      end
      user.save

    else
      user.email ||= email
      user.name = @name

      user.save
    end

    user

  end

end