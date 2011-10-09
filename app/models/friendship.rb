class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => :friend_id
  
  scope :pending, :conditions => "accepted_at is NULL"
  scope :accepted, :conditions => "accepted_at is NOT NULL"
end
