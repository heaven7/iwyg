class MessageMailer < ActionMailer::Base
  default :from => REPLY_EMAIL
  default :css => MAILER_CSS
  default :charset => MAILER_CHARSET

	layout 'layouts/mailer'

	def hasSendMessage(message, locale)	
		I18n.locale = locale.to_sym
		@subject = I18n.t("mailer.message.userHasSendMessage", :user => message.author.login)
		proceed_mail_with_subject(message, @subject)
	end

	def hasRepliedMessage(message, locale)	
		I18n.locale = locale.to_sym
		@subject = I18n.t("mailer.message.userHasRepliedMessage", :user => message.author.login)
		proceed_mail_with_subject(message, @subject)
	end

	private
	
	def proceed_mail_with_subject(message, subject)
		@message = message
		@sender = @message.author
		@message.recipients.each do |receiver|
			@receiver = receiver
			email_with_name = "#{@receiver.login} <#{@receiver.email}>"		 
			mail( :to => email_with_name, :subject => subject)		
		end
	end
end
