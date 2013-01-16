class GroupMailer < ActionMailer::Base
  default :from => REPLY_EMAIL
  default :css => :mailer
  default :charset => "UTF-8"

	layout 'layouts/mailer'

	def participation_request(grouping, receiver, subject)
    processEmail(grouping, receiver, subject)
  end

	def invitation(grouping, receiver, subject)
    processEmail(grouping, receiver, subject)
  end

	def participation_accepted(grouping, receiver, subject)
    processEmail(grouping, receiver, subject)
  end
	
	def invitation_accepted(grouping, receiver, subject)
    processEmail(grouping, receiver, subject)
  end

	def participation_aborted(grouping, receiver, subject)
    processEmail(grouping, receiver, subject)
  end

	def invitation_aborted(grouping, receiver, subject)
    processEmail(grouping, receiver, subject)
  end

	def quit_membership(grouping, receiver, subject)
    processEmail(grouping, receiver, subject)
	end

	def quit_membership_by_owner(grouping, receiver, subject)
    processEmail(grouping, receiver, subject)
	end

	private

	def processEmail(grouping, receiver, subject)
    @g = grouping
		email = "#{receiver.login} <#{receiver.email}>"
		mail( :to => email, 
					:subject => subject
		)
	end

end
