require 'active_record/fixtures'                                       

ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/db/migrate/data", "item_types")
ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/db/migrate/data", "item_statuses")
ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/db/migrate/data", "measures")
ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/db/migrate/data", "statuses")
