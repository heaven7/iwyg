# require 'rake/dsl_definition'

source 'https://rubygems.org'
# source 'http://gems.github.com'
# source 'http://gemcutter.org'

gem 'rails', '3.2.13'

group :assets do
  gem 'sass-rails', '~> 3.2.0'
  gem 'coffee-rails', '~> 3.2.0'
  gem 'uglifier'
	gem 'compass-rails'
end

group :production, :stage do
  gem 'mysql2' #, '0.2.18'
end

gem 'omniauth-facebook'
gem 'meta-tags', :require => 'meta_tags'
gem 'i18n_country_select'
gem 'liangzan-contacts', :require => 'contacts' #, :git => '../contacts.git'
#gem 'contacts'
gem 'rails-settings-cached', '0.2.4'
gem 'rails_config'
#gem 'rails-settings', :git => 'git://github.com/100hz/rails-settings.git'
gem 'socialization'
gem 'rails-i18n'
gem 'daemons'
gem 'delayed_job', '3.0.1'
gem 'delayed_job_active_record'
gem 'impressionist'
gem 'formatize'
gem 'rails_autolink', '1.1.4'
gem 'sanitize'

gem 'rabl'
gem 'oj'
gem 'airbrake'
gem 'eventmachine', '1.0.0.beta.2'
gem 'thin'
gem 'therubyracer', '0.10.2', :platform => :ruby

gem 'geocoder', '1.1.8'
gem 'gmaps4rails', '1.4.5'
gem 'rgeo'
gem 'rgeo-geojson'
gem 'rgeo-activerecord'
gem 'activerecord-mysql2spatial-adapter'

gem 'hpricot'
gem 'redis'
gem 'sqlite3-ruby'
gem 'inherited_resources'
gem 'has_scope'
gem 'squeel'
gem 'ransack'
gem 'routing-filter', '0.3.0'
gem 'friendly_id', '4.0.9'
gem 'paper_trail'
gem 'json_pure', '1.6.1'   
gem 'jquery-rails' #, '>= 1.0.12'
gem 'rails3-jquery-autocomplete'
gem 'formtastic' #, '2.1.0.beta1'
gem 'client_side_validations'
gem 'client_side_validations-formtastic'
gem 'nested_form'
gem 'devise', '~> 2.0.6' #, :git => 'git://github.com/plataformatec/devise.git'
gem 'cancan'
gem 'devise_rpx_connectable'
#gem 'ajaxful_rating', '2.2.8.2'
gem 'acts-as-taggable-on', '~> 2.2.2'
gem 'paperclip', '= 3.0.4'
gem 'cocaine', '= 0.3.2'
gem 'rmagick' 
#gem 'meta_search'
gem 'will_paginate', '3.0.3'
gem 'validates_timeliness' #, '2.3.2'
gem 'roadie'
gem 'roadie-rails'
#gem 'acts_as_follower'
gem 'acts_as_audited', '~> 2.1.0'
gem 'rails3_acts_as_paranoid'

group :development do 
  gem 'better_errors', '>= 0.3.2'
end

group :development, :test do
  gem 'meta_request'
  gem 'mongrel', '>= 1.2.0.pre2'
  gem 'rspec-rails', ">= 2.8.1"
  gem 'factory_girl_rails', '>= 1.6.0'
  gem 'capybara-webkit' #, '~> 0.7.2'
  gem 'database_cleaner' #, '~> 0.6.7'
  gem 'guard-spork' #, '1.2.0'
  gem 'spork' #, '0.9.2'
  gem 'rack-mini-profiler'
end

group :test do
	gem "cucumber-rails", ">= 1.2.1", :require => false
  gem 'rubyzip', '~> 0.9.9'
  gem 'fakeweb'
  gem 'email_spec'
  gem 'mysql2' #, '0.2.18'
  gem 'capybara', '1.1.4'
	gem 'selenium-webdriver' #, '2.25.0'
	gem 'Selenium'
	gem 'selenium-client', '1.2.16'
	gem 'launchy'
	gem 'guard'  
	gem 'guard-rspec'
	gem 'rb-inotify', '~> 0.8.8'
	gem 'populator'
  gem 'faker'
	gem 'shoulda'  
	gem 'shoulda-matchers'
	gem 'fakeweb'
end

