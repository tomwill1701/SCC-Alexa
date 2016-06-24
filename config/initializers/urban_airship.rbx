
if ENV["ALERT_MASTER"]  && ENV["ALERT_SECRET"]
  Urbanairship.application_key = "yu0NtsbAQZGyMlLRUV4Apw"
  Urbanairship.application_secret = ENV["ALERT_SECRET"]
  Urbanairship.master_secret = ENV["ALERT_MASTER"]
  Urbanairship.logger = Rails.logger
  Urbanairship.request_timeout = 5 # default
end