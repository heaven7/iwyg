class ActionMailer::Localized < ActionMailer::Base
    private
    # we override the template_path to render localized templates (since rails does not support that :-( )
    # This thing is not testable since you cannot access the instance of a mailer...
    def initialize_defaults(method_name)
      super
      @template = "#{I18n.locale}_#{method_name}"
   end
end

class MeetupMailer < ActionMailer::Base
  default :from => REPLY_EMAIL
  default :css => AppSettings.mailer.css
  default :charset => AppSettings.mailer.charset

  def invitation(meetup, user, owner)
    @user = user
    email_with_name = "#{user.login} <#{user.email}>"
    @owner = owner
    @meetup_url = "#{HOST}/meetups/#{meetup.id}"
    mail( :to => email_with_name, :subject => I18n.t("mailer.meetup.invitation", :user => @owner.login) )
  end
  
end
