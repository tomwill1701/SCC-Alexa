# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  :address        => ENV['EMAIL_SMTP'],
  :port           => ENV['EMAIL_PORT'],
  :authentication => :plain,
  :user_name      => ENV['EMAIL_USERNAME'],
  :password       => ENV['EMAIL_PASSWORD'],
  :domain         => 'sample.com',
  :enable_starttls_auto => true
}

