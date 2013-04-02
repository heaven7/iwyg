class UserMailer < ActionMailer::Base
  default :from => REPLY_EMAIL
  default :css => :mailer
  default :charset => "UTF-8"

  def registration_notification(user)
    @user = user
    @url = "#{HOST}/users/sign_in"
    email_with_name = "#{@user.login} <#{@user.email}>"
    mail( :to => email_with_name, :subject => "IWYG Registration")
  end

  def comment(user) 
    @recipients  = user[:owner].email
    @subject     = user[:subject]
    @from        = "#{REPLY_EMAIL}"
    @sent_on     = Time.now
    @body = user 
  end

	def activation_instructions(user)
		@user = user
		@activation_url = user_unlock_url
    email_with_name = "#{@user.login} <#{@user.email}>"
		mail( :to => email_with_name, :subject => "IWYG account activation")
	end

	def sendInvitation(invitation, friend, signup_url)
		@user = invitation.sender
		@name = friend.name
		@email = friend.email
		@signup_url = signup_url
		mail( :to => "#{@name}<#{@email}>", :subject => "Invitation from #{@name}")
	end
end
