class Invitation < ActiveRecord::Base
  attr_accessible :emails, :invitationmessage, :sender_id

	belongs_to :sender, :class_name => "User"
	has_many :friendships, :class_name => "Friendship"

	PROVIDERS = 
	[
		["AOL", "aol"],
	 	["GMail","gmail"],
	 	["Gmx.net","gmx"],
	 	["Hotmail","hotmail"],
	 	["Inbox.lt","inbox_lt"],
	 	["Mail.ru","mail_ru"],
	 	["One.lt","onelt"],
	 	["Plaxo","plaxo"],
	 	["Seznam.cz","seznam"],
	 	["T-Online","tonline_de"],
	 	["Web.de","web_de"],
	 	["Yahoo","yahoo"]
	]

	validates :emails, :presence => true
	validates :invitationmessage, :presence => true
	#validates_presence_of :emails
	#validates_presence_of :invitationmessage
	
end
