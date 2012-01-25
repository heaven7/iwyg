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

gem 'json_pure', '1.6.1'   
gem 'jquery-rails' #, '>= 1.0.12'
gem 'rails3-jquery-autocomplete'
gem 'devise' #, :git => 'git://github.com/plataformatec/devise.git'   
gem 'devise_rpx_connectable'
gem 'formtastic', '~> 2.0'
gem 'geocoder'
gem 'gmaps4rails'
gem 'ajaxful_rating', '2.2.8.2'
gem 'acts-as-taggable-on', '~> 2.2.2'
gem 'inherited_resources'
gem 'has_scope'
gem 'paperclip'
#gem 'meta_search'
gem 'meta_where'
gem "ransack"
gem 'routing-filter', '0.2.3'
gem 'will_paginate', '~> 3.0'
gem 'validates_timeliness' #, '2.3.2'
gem 'mysql2', '0.2.6'
gem 'mongrel', '>= 1.2.0.pre2'
gem 'roadie'
gem "acts_as_follower"

gem "rspec-rails", :group => [:test, :development]

gem "factory_girl_rails", '1.6.0'
group :test do
  gem "capybara"
  gem "guard-rspec"
  gem "populator"
  gem "faker"
end

