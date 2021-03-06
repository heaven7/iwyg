Webrat.configure do |config|
  config.mode = :selenium
  # Selenium defaults to using the selenium environment. Use the following to override this.
  # config.application_environment = :test
end

# this is necessary to have webrat "wait_for" the response body to be available
# when writing steps that match against the response body returned by selenium
World(Webrat::Selenium::Matchers)

Before do 
  	require File.dirname(__FILE__) + '/../../db/seeds.rb'	
end

After do
  # truncate your tables here, since you can't use transactional fixtures*
	require 'database_cleaner'
	DatabaseCleaner.clean_with :truncation
#	DatabaseCleaner.strategy = :transaction
end
