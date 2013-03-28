class Invitation < ActiveRecord::Base
  attr_accessible :emails, :invitationmessage, :password, :sender_id, :username, :provider, :providerlist
	attr_accessor :providerlist

	belongs_to :sender, :class_name => "User"

	def providerlist
		self.providerlist = ["GMail", "Yahoo", "Hotmail"]	
	end
end
