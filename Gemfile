# require 'rake/dsl_definition'

source :rubygems
# source 'http://gems.github.com'
# source 'http://gemcutter.org'

gem 'rails', '3.0.10'

#group :assets do
#  gem 'sass-rails',   '~> 3.1.5.rc.2'
#  gem 'coffee-rails', '~> 3.1.1'
#  gem 'uglifier', '>= 1.0.3'
#end

group :production, :stage do
  gem 'mysql2' , '0.2.18'
end

group :development do 
  gem 'mongrel', '>= 1.2.0.pre2'
end

gem 'geokit'
gem 'hpricot'
gem 'redis'
gem 'sqlite3-ruby'
gem 'inherited_resources'
gem 'has_scope'
gem 'meta_where'
gem "ransack"
gem 'routing-filter', '0.2.3'
gem "friendly_id", "4.0"
gem "paper_trail"
gem 'json_pure', '1.6.1'   
gem 'jquery-rails' #, '>= 1.0.12'
gem 'rails3-jquery-autocomplete'
gem 'client_side_validations'

gem 'devise' #, '2.0.0' # , :git => 'git://github.com/plataformatec/devise.git'
gem 'devise_rpx_connectable'
gem 'formtastic', '2.1.0.beta1'
gem 'geocoder'
gem 'gmaps4rails', '1.4.5'
gem 'ajaxful_rating', '2.2.8.2'
gem 'acts-as-taggable-on', '~> 2.2.2'
gem 'paperclip'
#gem 'meta_search'
gem 'will_paginate', '~> 3.0'
gem 'validates_timeliness' #, '2.3.2'
gem 'roadie'
gem "acts_as_follower"
gem "acts_as_audited", "~> 2.1.0"
gem "rails3_acts_as_paranoid"

group :test do
  gem 'mysql2' , '0.2.18'
  #  gem "capybara"
  #  gem "guard-rspec"
  gem "factory_girl_rails", '1.6.0'
  gem "rspec-rails"
  gem "populator"
  gem "faker"
end

