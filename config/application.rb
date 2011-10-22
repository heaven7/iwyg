require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Iwyg
  class Application < Rails::Application
    
    config.plugins = [:all]
    #config.time_zone = 'UTC'
    config.encoding = 'utf-8' 
    
    # The user observer goes inside the Rails::Initializer block
    config.active_record.observers = :user_observer, :ping_observer, :transfer_observer, :comment_observer, :event_observer
    #config.filter_parameters += [:password]
  end
end

# application configuration
DB_STRING_MAX_LENGTH = 255
HTML_TEXT_FIELD_SIZE = 30
ITEMS_PER_PAGE = 25
TRANSFERS_PER_PAGE = 10
PINGS_PER_PAGE = 10

# Default date/time format
#ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(:default => "%B %d, %Y")
#ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(:default => "%B %d, %Y %H:%m",
#                                                                      :weekday => "%A: %B %d, %Y")

# Time::DATE_FORMATS[:mailbox] = "%A, %B %d, %Y"

# hirb
if $0 == 'irb'
  require 'hirb'
  Hirb.enable
end
