class GroupMailer < ActionMailer::Base
  default :from => REPLY_EMAIL
  default :css => :mailer
  default :charset => "UTF-8"

	layout 'layouts/mailer'

	def participation_request(grouping, sender, receiver, subject)
    processEmail(grouping, sender, receiver, subject)
  end

	def invitation(grouping, sender, receiver, subject)
    processEmail(grouping, sender, receiver, subject)
  end

	def participation_accepted(grouping, sender, receiver, subject)
    processEmail(grouping, sender, receiver, subject)
  end
	
	def invitation_accepted(grouping, sender, receiver, subject)
    processEmail(grouping, sender, receiver, subject)
  end

	def participation_aborted(grouping, sender, receiver, subject)
    processEmail(grouping, sender, receiver, subject)
  end

	def invitation_aborted(grouping, sender, receiver, subject)
    processEmail(grouping, sender, receiver, subject)
  end

	def quit_membership(grouping, sender, receiver, subject)
    processEmail(grouping, sender, receiver, subject)
	end

	def quit_membership_by_owner(grouping, sender, receiver, subject)
    processEmail(grouping, sender, receiver, subject)
	end

	private

	def processEmail(grouping, sender, receiver, subject)
    @g = grouping
		@receiver = receiver
		@sender = sender
		email = "#{receiver.login} <#{receiver.email}>"
		mail( :to => email, 
					:subject => subject
		)
	end

end
