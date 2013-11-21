require 'rails_config'
#RailsConfig.load_and_set_settings("/config/settings.yml")

RailsConfig.setup do |config|
  config.const_name = "AppSettings"
end
