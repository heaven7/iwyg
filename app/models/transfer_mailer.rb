class ActionMailer::Localized < ActionMailer::Base
    private
    # we override the template_path to render localized templates (since rails does not support that :-( )
    # This thing is not testable since you cannot access the instance of a mailer...
    def initialize_defaults(method_name)
      super
      @template = "#{I18n.locale}_#{method_name}"
   end
end

class TransferMailer < ActionMailer::Localized

  def transfer_opened(mail)
    recipients  mail[:receiver].email
    setup_email(mail)  
  end  
  
  def transfer_accepted(mail)
    recipients  mail[:user].email
    setup_email(mail)
  end
  
  def transfer_updated(mail)
    recipients  mail[:user].email
    setup_email(mail)
  end
  
  def transfer_declined(mail)
    recipients  mail[:user].email
    setup_email(mail)
  end
  
  def transfer_closed(mail)
    recipients  mail[:user].email
    setup_email(mail)
  end    
  
  protected
  def setup_email(mail)
    from        "#{REPLY_EMAIL}"
    subject     mail[:subject]
    sent_on     Time.now
    body        mail
  end

end
