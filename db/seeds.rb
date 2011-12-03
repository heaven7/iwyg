require 'active_record/fixtures'                                       

Fixtures.create_fixtures("#{Rails.root}/db/migrate/data", "item_types")  
Fixtures.create_fixtures("#{Rails.root}/db/migrate/data", "item_statuses")
Fixtures.create_fixtures("#{Rails.root}/db/migrate/data", "measures")   
