class Ability
  include CanCan::Ability

  def initialize(user)
		user ||= User.new # guest user (not logged in)
		can :read, User, :is_active => true
		
		if user.id.nil?
		
		else
			can :manage, User
		end	
  end
end
