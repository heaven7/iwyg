Iwyg::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

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

  #config.action_mailer.smtp_settings = {
  #    :address => "mail.heavenseven.net",
  #    :port => 587,
  #    :domain => "www.heavenseven.net",
  #    :user_name => "iwyg+heavenseven.net",
  #    :password => "r1NmhzzisQw9",
  #    :authentication => :plain
  # }
   
  # application configuration
  HOST = "http://localhost:3000"
  REPLY_EMAIL = "iwyg@heavenseven.net" 
  Paperclip.options[:command_path] = "D:/Programme/ImageMagick-6.6.3-Q16"
end

