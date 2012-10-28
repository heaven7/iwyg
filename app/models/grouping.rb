class Grouping < ActiveRecord::Base
  attr_accessible :user_id, :group_id
  belongs_to :user
  belongs_to :group

  scope :pending, :conditions => "accepted_at is NULL"
  scope :accepted, :conditions => "accepted_at is NOT NULL"
end
