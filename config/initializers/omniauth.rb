require 'rails_config'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, AppSettings.fb_key, AppSettings.fb_secret
end