require File.expand_path('../boot', __FILE__)

require 'rails/all'

# rails < 3.1
# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
# Bundler.require(:default, Rails.env) if defined?(Bundler)

# rails > 3.1
if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Iwyg
  class Application < Rails::Application

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Change the path that assets are served from
    # config.assets.prefix = "/assets"
    
    config.plugins = [:all]
    #config.time_zone = 'UTC'
    config.encoding = 'utf-8' 
    I18n.available_locales = [:de, :en]
    
    # Custom directories with classes and modules you want to be autoloadable.    
    config.autoload_paths += %W(#{config.root}/lib)

    config.filter_parameters += [:password, :password_confirmation]
    
    # Loading Js-Files automatically
    config.action_view.javascript_expansions = { :defaults => %w(jquery jquery-ui jquery_ujs ) } 
    
    # Observers
    config.active_record.observers = :user_observer, :ping_observer, :meetup_observer #, :transfer_observer, :comment_observer, :event_observer
  end
end

# application configuration
DB_STRING_MAX_LENGTH = 255
HTML_TEXT_FIELD_SIZE = 30
ITEMS_PER_PAGE = 24
ITEMS_RELATED_PER_PAGE = 6
USERS_PER_PAGE = 24
GROUPS_PER_PAGE = 24
TRANSFERS_PER_PAGE = 30
PINGS_PER_PAGE = 30

MAILER_CSS = :mailer
MAILER_CHARSET = "UTF-8"

# Default date/time format
# date.formats(:default=> "%B %d, %Y")
# ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(:default => "%B %d, %Y")
# ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(:default => "%B %d, %Y %H:%m",
#                                                                      :weekday => "%A: %B %d, %Y")

Time::DATE_FORMATS[:mailbox] = "%A, %B %d, %Y"
Time::DATE_FORMATS[:default] = "%B %d, %Y"

# hirb
if $0 == 'irb'
  require 'hirb'
  Hirb.enable
end

