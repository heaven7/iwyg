# truncate your tables here if you are using the same database as selenium, since selenium doesn't use transactional fixtures
require 'database_cleaner'
DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :transaction
# Cucumber::Rails.use_transactional_fixtures = true
