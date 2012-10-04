class UserPreferences < ActiveRecord::Base
  attr_accessible :active, :custom_id, :language, :user_id
end
