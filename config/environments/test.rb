# encoding: utf-8

Iwyg::Application.configure do

  config.use_transactional_fixtures = false

  I18n.default_locale = :en
  
  # Allow pass debug_assets=true as a query parameter to load pages with unpackaged assets
  config.assets.allow_debugging = true

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # Allow pass debug_assets=true as a query parameter to load pages with unpackaged assets
  config.assets.allow_debugging = true

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
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
  REPLY_EMAIL = "iwyg@heavenseven.net"
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
    FACEBOOK_KEY = AppSettings.fb_key
    FACEBOOK_SECRET = AppSettings.fb_secret
    MAILER_CSS = AppSettings.mailer.css
    MAILER_CHARSET = AppSettings.mailer.charset
  end
  # Paperclip.options[:command_path] = "D:/Programme/ImageMagick-6.6.3-Q16"

end

