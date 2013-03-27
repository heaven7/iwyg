class Invitation < ActiveRecord::Base
  attr_accessible :emails, :invitationmessage, :password, :sender_id, :username
end
