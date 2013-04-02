class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => :friend_id
	belongs_to :invitation, :class_name => "Invitation", :foreign_key => :invitation_id  
  scope :pending, :conditions => "accepted_at is NULL"
  scope :accepted, :conditions => "accepted_at is NOT NULL"

	def generate_token
		self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
	end
end
