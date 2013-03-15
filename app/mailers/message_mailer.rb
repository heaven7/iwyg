class MessageMailer < ActionMailer::Base
  default :from => REPLY_EMAIL
  default :css => MAILER_CSS
  default :charset => MAILER_CHARSET

	def hasSendMessage(message)
		message.recipients.each do |receiver|
			@receiver = receiver
			@sender = message.author
			email_with_name = "#{@receiver.login} <#{@receiver.email}>"
		  mail( :to => email_with_name, :subject => I18n.t("mailer.message.userHasSendMessage", :user => @sender.login) )
		end
	end
end
