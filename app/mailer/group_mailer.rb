class GroupMailer < ActionMailer::Base
  default :from => REPLY_EMAIL
  default :css => :mailer
  default :charset => "UTF-8"

	def participation(grouping)
    @user = user
		@group = Group.find(grouping.group_id)
    @url = "#{HOST}/grouping/#{grouping.id}/accept"
    email_with_name = "#{@group.owner.login} <#{@group.owner.email}>"
    mail( :to => email_with_name, :subject => "Group #{@group.title.html_safe}")
  end
end
