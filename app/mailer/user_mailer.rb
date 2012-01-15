class UserMailer < ActionMailer::Base
  default :from => REPLY_EMAIL
  default :charset => "UTF-8"

  def registration_notification(user)
    @user = user
    @url = "#{HOST}/users/sign_in"
    email_with_name = "#{user.login} <#{user.email}>"
    mail( :to => email_with_name, :subject => "IWYG Registration")
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
