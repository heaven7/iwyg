class ActionMailer::Localized < ActionMailer::Base
    private
    # we override the template_path to render localized templates (since rails does not support that :-( )
    # This thing is not testable since you cannot access the instance of a mailer...
    def initialize_defaults(method_name)
      super
      @template = "#{method_name}.#{I18n.locale}"
   end
end

class MessageMailer < ActionMailer::Localized
  default :from => REPLY_EMAIL
  default :css => MAILER_CSS
  default :charset => MAILER_CHARSET

	def hasSendMessage(message)	
		@message = message
		@sender = @message.author
		@message.recipients.each do |receiver|
			@receiver = receiver
			email_with_name = "#{@receiver.login} <#{@receiver.email}>"
		  mail( :to => email_with_name, :subject => I18n.t("mailer.message.userHasSendMessage", :user => @sender.login) )
		end
	end

	def hasRepliedMessage(message)	
		@message = message
		@sender = @message.author
		@message.recipients.each do |receiver|
			email_with_name = "#{@receiver.login} <#{@receiver.email}>"
		  mail( :to => email_with_name, :subject => I18n.t("mailer.message.userHasRepliedMessage", :user => @sender.login) )
		end
	end
end
