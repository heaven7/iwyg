require 'rake/dsl_definition'

source :rubygems
# source 'http://gems.github.com'
# source 'http://gemcutter.org'

gem 'rails', '3.0.10'

#gem 'rdoc-data'

group :production, :stage do
  gem 'hpricot'
end

group :development do 
  gem 'hpricot' 
end

group :stage do
  gem 'geokit'
end

gem 'mysql2', '0.2.6'
gem 'mongrel', '>= 1.2.0.pre2'
gem 'inherited_resources'
gem 'has_scope'
gem 'meta_where'
gem "ransack"
gem 'routing-filter', '0.2.3'
gem "friendly_id", "~> 4.0.0"

gem 'json_pure', '1.6.1'   
gem 'jquery-rails' #, '>= 1.0.12'
gem 'rails3-jquery-autocomplete'
gem 'client_side_validations'

gem 'devise' #, :git => 'git://github.com/plataformatec/devise.git'   
gem 'devise_rpx_connectable'
gem 'formtastic' #, '2.1.0.beta1'
gem 'geocoder'
gem 'gmaps4rails'
gem 'ajaxful_rating', '2.2.8.2'
gem 'acts-as-taggable-on', '~> 2.2.2'
gem 'paperclip'
#gem 'meta_search'
gem 'will_paginate', '~> 3.0'
gem 'validates_timeliness' #, '2.3.2'
gem 'roadie'
gem "acts_as_follower"
gem "acts_as_audited", "2.0.0"

gem "rspec-rails", :group => [:test, :development]

gem "factory_girl_rails", '1.6.0'
group :test do
  gem "capybara"
  gem "guard-rspec"
  gem "populator"
  gem "faker"
end

