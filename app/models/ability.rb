class Ability
  include CanCan::Ability

  def initialize(user)
		user ||= User.new # guest user (not logged in)
		can :read, User, :is_active => true
		can :read, Item do |item|
			item.custom.visible == true
		end			
		if user.id.nil?
		
		else
			can :manage, User, :id => user.id
			can :show, Item do |item|
				can?(:show, item) && item.can_be_read_by?(user)
			end
		end	
  end
end
