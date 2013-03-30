class Invitation < ActiveRecord::Base
  attr_accessible :emails, :invitationmessage, :sender_id

	belongs_to :sender, :class_name => "User"

	PROVIDER = ["GMail", "Yahoo", "Hotmail"]
end
