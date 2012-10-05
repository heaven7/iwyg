class UserPreferences < ActiveRecord::Base
  attr_accessible :active, :custom_id, :language, :user_id

	belongs_to :user
end
