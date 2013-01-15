class GroupMailer < ActionMailer::Base
  default :from => REPLY_EMAIL
  default :css => :mailer
  default :charset => "UTF-8"

	layout 'layouts/mailer'

	def participation_request(grouping)
    @g = grouping
		@group = @g.group
		@sender = @g.owner
		@email_with_name = "#{@group.owner.login} <#{@group.owner.email}>"
		@subject = t("mailer.group.participation_request", :sender => @sender.login, :title => @group.title).html_safe
		mail( :to => @email_with_name, 
					:subject => @subject
		)
  end

	def invitation(grouping)
    @g = grouping
		@group = @g.group
		@sender = @group.owner
		@email_with_name = "#{@g.user.login} <#{@g.user.email}>"
		@subject = t("mailer.group.invitation", :sender => @sender.login, :title => @group.title).html_safe
		mail( :to => @email_with_name, 
					:subject => @subject
		)
  end

	def participation_accepted(grouping)
		@g = grouping
		@group = @g.group
		@sender = @group.owner
		@email_with_name = "#{@g.user.login} <#{@g.user.email}>"
		@subject = t("mailer.group.participation_accepted", :sender => @sender.login, :title => @group.title).html_safe
		mail( :to => @email_with_name, 
					:subject => @subject
		)
  end
	
	def invitation_accepted(grouping)
		@g = grouping
		@group = @g.group
		@sender = @g.user
		@email_with_name = "#{@group.owner.login} <#{@group.owner.email}>"
		@subject = t("mailer.group.invitation_accepted", :sender => @sender.login, :title => @group.title).html_safe
		mail( :to => @email_with_name, 
					:subject => @subject
		)
  end

	def participation_aborted(grouping)
		@g = grouping
		@group = @g.group
		@sender = @group.owner
		@email_with_name = "#{@g.user.login} <#{@g.user.email}>"
		@subject = t("mailer.group.participation_aborted", :sender => @sender.login, :title => @group.title).html_safe
		mail( :to => @email_with_name, 
					:subject => @subject
		)
  end

	def invitation_aborted(grouping)
    @g = grouping
		@group = @g.group
		@sender = @g.user
		@email_with_name = "#{@group.owner.login} <#{@group.owner.email}>"
		@subject = t("mailer.group.invitation_aborted", :sender => @sender.login, :title => @group.title).html_safe
		mail( :to => @email_with_name, 
					:subject => @subject
		)
  end

	def quit_membership(grouping)
		@g = grouping
		@group = @g.group
		@sender = @g.user
		@email_with_name = "#{@group.owner.login} <#{@group.owner.email}>"
		@subject = t("mailer.group.quit_membership", :sender => @sender.login, :title => @group.title).html_safe
		mail( :to => @email_with_name, 
					:subject => @subject
		)
	end

	def quit_membership_by_owner(grouping)
		@g = grouping
		@group = @g.group
		@sender = @group.owner
		@email_with_name = "#{@g.user.login} <#{@g.user.email}>"
		@subject = t("mailer.group.quit_membership_by_owner", :sender => @sender.login, :title => @group.title).html_safe
		mail( :to => @email_with_name, 
					:subject => @subject
		)
	end

end
