class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.registration_notification(user).deliver
  end

  def after_save(user)  
   # UserMailer.activation_instructions(user).deliver if not user.active_for_authentication?
  end
end
