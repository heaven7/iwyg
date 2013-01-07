class GroupMailer < ActionMailer::Base
  default :from => REPLY_EMAIL
  default :css => :mailer
  default :charset => "UTF-8"

	def participation_request(grouping)
    @sender = User.find(grouping.user_id)
		@group = Group.find(grouping.group_id)
    @url = "#{HOST}/grouping/#{grouping.id}/accept"
    email_with_name = "#{@group.owner.login} <#{@group.owner.email}>"
    mail( :to => email_with_name, 
					:subject => t("mailer.group.participation_request", :sender => @sender.login, :title => @group.title).html_safe
		)
  end

	def participation_accepted(grouping)
		@group = Group.find(grouping.group_id)
    email_with_name = "#{grouping.owner.login} <#{grouping.owner.email}>"
    mail( :to => email_with_name, 
					:subject => t("mailer.group.participation_accepted", :title => @group.title).html_safe
		)
  end

	def participation_aborted(grouping)
    @sender = User.find(grouping.user_id)
		@group = Group.find(grouping.group_id)
    @url = "#{HOST}/grouping/#{grouping.id}/accept"
    email_with_name = "#{@group.owner.login} <#{@group.owner.email}>"
    mail( :to => email_with_name, 
					:subject => t("mailer.group.participation_aborted", :sender => @sender.login, :title => @group.title).html_safe
		)
  end

end
