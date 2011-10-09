class ActionMailer::Localized < ActionMailer::Base
    private
    # we override the template_path to render localized templates (since rails does not support that :-( )
    # This thing is not testable since you cannot access the instance of a mailer...
    def initialize_defaults(method_name)
      super
      @template = "#{I18n.locale}_#{method_name}"
   end
end

class UserMailer < ActionMailer::Localized
  def signup_notification(user)
    setup_email(user)
    @subject    += I18n.translate("user.account.pleaseactivate")
  
    @body[:url]  = "#{HOST}/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += I18n.translate("user.account.activated")
    @body[:url]  = "#{HOST}/"
  end
  
  def comment(user) 
    @recipients  = user[:owner].email
    @subject     = user[:subject]
    @from        = "#{REPLY_EMAIL}"
    @sent_on     = Time.now
    @body = user 
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "#{REPLY_EMAIL}"
      @subject     = "IWYG: "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
