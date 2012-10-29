class Grouping < ActiveRecord::Base
  attr_accessible :user_id, :group_id
  belongs_to :user
  belongs_to :group

  scope :pending, :conditions => "accepted_at is NULL"
  scope :accepted, :conditions => "accepted_at is NOT NULL"

	def exists?
		not Grouping.find_by_user_id_and_group_id(self.user_id, self.group_id).nil?
	end
end
