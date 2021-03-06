Iwyg::Application.configure do

  # Compress JavaScripts and CSS
  config.assets.compress = true

  I18n.default_locale = :de 

  # Choose the compressors to use
  # config.assets.js_compressor  = :uglifier
  # config.assets.css_compressor = :yui

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Add the fonts path
  config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = true
	config.assets.precompile += %w[*.png *.jpg *.jpeg *.gif]
  config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
  # devise 
  config.action_mailer.default_url_options = { :host => 'www.iwyg.net' }
  
  # application configuration
  HOST = "http://www.iwyg.net"
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
end
