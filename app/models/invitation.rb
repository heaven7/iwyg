class Invitation < ActiveRecord::Base
  attr_accessible :emails, :invitationmessage, :sender_id

	belongs_to :sender, :class_name => "User"
	has_many :friendships, :class_name => "Friendship"

	PROVIDER = ["GMail", "Yahoo", "Hotmail"]

	validates_presence_of :emails, :invitationmessage
end
