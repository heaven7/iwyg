require File.expand_path('../boot', __FILE__)

require 'rails/all'

# rails < 3.1
# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
# Bundler.require(:default, Rails.env) if defined?(Bundler)

# rails > 3.1
if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  # Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in production, use this line
  Bundler.require(:default, :assets, Rails.env)
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
    config.active_record.observers = :user_observer, :ping_observer, :meetup_observer, :comment_observer, :grouping_observer

		# testing
		config.generators do |g|
			g.test_framework :rspec,
				:fixtures => true,
				:view_specs => false,
				:helper_specs => false,
				:routing_specs => false,
				:controller_specs => true,
				:request_specs => true
			g.fixture_replacement :factory_girl, :dir => "spec"
			g.form_builder :formtastic		
		end

  end
end
ActionDispatch::Callbacks.after do
  # Reload the factories
  return unless (Rails.env.development? || Rails.env.test?)

  unless FactoryGirl.factories.blank? # first init will load factories, this should only run on subsequent reloads
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
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
GOOGLE_ANALYTICS_ID = 'UA-32738329-1'
MAILER_CSS = :mailer
MAILER_CHARSET = "UTF-8"
ITEMTYPES = ["good", "transport", "service", "sharingpoint", "knowledge", "skill"]

# default date/time format
Time::DATE_FORMATS[:mailbox] = "%A, %B %d, %Y"
Time::DATE_FORMATS[:default] = "%B %d, %Y"
Time::DATE_FORMATS[:forms] = "%d.%m.%Y %H:%M"

# hirb
if $0 == 'irb'
  require 'hirb'
  Hirb.enable
end

