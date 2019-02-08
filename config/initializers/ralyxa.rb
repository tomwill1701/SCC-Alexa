Ralyxa.configure do |config|
  config.validate_requests = Rails.env.production?
end