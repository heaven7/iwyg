# encoding: utf-8

Iwyg::Application.configure do

  # Caching
  config.perform_caching = false

  I18n.default_locale = :de   

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Assets
  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Caching of classes
  config.cache_classes = false

  config.serve_static_assets = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.log_level = :debug
  # config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  # devise 
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  
  # actionmailer
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
   
  # application configuration
  HOST = "http://localhost:3000"
  REPLY_EMAIL = "IWYG <iwyg@heavenseven.net>"	

  config.after_initialize do    
    DB_STRING_MAX_LENGTH = 255
    HTML_TEXT_FIELD_SIZE = 30
    ITEMTYPES = AppSettings.itemtypes
    ITEMS_PER_PAGE = AppSettings.items.per_page
    ITEMS_RELATED_PER_PAGE = AppSettings.items.related_per_page
    USERS_PER_PAGE = AppSettings.users.per_page
    GROUPS_PER_PAGE = AppSettings.groups.per_page
    PINGS_PER_PAGE = AppSettings.pings.per_page
    GOOGLE_ANALYTICS_ID = AppSettings.google.analytics_id
    MAILER_CSS = AppSettings.mailer.css
    MAILER_CHARSET = AppSettings.mailer.charset
  end

  config.before_initialize do 
    FACEBOOK_KEY = AppSettings.fb_key
    FACEBOOK_SECRET = AppSettings.fb_secret
  end

	# Paperclip settings
	# set command path on windows (example)
  # Paperclip.options[:command_path] = "D:/Programme/ImageMagick-6.6.3-Q16"

	# set command path on linux (example)
	Paperclip.options[:command_path] = "/usr/lib/"
end

class ActionDispatch::Request
 def local?
   true
 end
end

class ActionDispatch::ShowExceptions
  def local_request?(*args)
    true
  end
end
