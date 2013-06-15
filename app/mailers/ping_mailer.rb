class ActionMailer::Localized < ActionMailer::Base
  private
  # we override the template_path to render localized templates (since rails does not support that :-( )
  # This thing is not testable since you cannot access the instance of a mailer...
  def initialize_defaults(method_name)
    super
    @template = "#{I18n.locale}_#{method_name}"
  end
end

class PingMailer < ActionMailer::Localized
  default :from => REPLY_EMAIL
  default :css => AppSettings.mailer.css
  default :charset => AppSettings.mailer.charset

  def ping_opened(resource, user, holder, message, ping)
    @host = HOST
    @message = message
    @resource = resource
    @ping = ping
    @user = user
    @holder = holder
    @subject = "IWYG PingMailer"
    @user_url = "#{@host}/users/#{@user.id}"
    @holder_pings_url = "#{@host}/users/#{@holder.id}/pings"
    @ping_url = "#{@host}/pings/#{@ping.id}/"

    email_with_name = "#{@holder.login} <#{@holder.email}>"
    mail( :to => email_with_name, :subject => @subject )
  end  
  
  def ping_updated(resource, user, holder, action, message, ping)
    @host = HOST
    @message = message
    @resource = resource
    @action = action
    @ping = ping
    @user = user
    @holder = holder
    @subject = "IWYG PingMailer"
    @user_url = "#{@host}/users/#{@user.id}"
    @holder_pings_url = "#{@host}/users/#{@holder.id}/pings"
    @ping_url = "#{@host}/pings/#{@ping.id}/"

    email_with_name = "#{@user.login} <#{@user.email}>"
    mail( :to => email_with_name, :subject => @subject )
  end

  def ping_accepted(mail)
    recipients  mail[:user].email
    setup_email(mail)
  end
  
  def ping_declined(mail)
    recipients  mail[:user].email
    setup_email(mail)
  end
  
  def ping_closed(mail)
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
