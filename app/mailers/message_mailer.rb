class MessageMailer < ActionMailer::Base
  default :from => REPLY_EMAIL
  default :css => MAILER_CSS
  default :charset => MAILER_CHARSET

	layout 'layouts/mailer'

	def hasSendMessage(message, locale, subject)	
		proceed_mail_with_subject(message, locale, subject)
	end

	def hasRepliedMessage(message, locale, subject)	
		proceed_mail_with_subject(message, locale, subject)
	end

	private
	
	def proceed_mail_with_subject(message, locale, subject)
		I18n.locale = locale.to_sym
		@message = message
		@sender = @message.author
		@subject = I18n.t(subject, :user => @sender.login)
		@message.recipients.each do |receiver|
			@receiver = receiver
			email_with_name = "#{@receiver.login} <#{@receiver.email}>"		 
			mail( :to => email_with_name, :subject => @subject )		
		end
	end
end
