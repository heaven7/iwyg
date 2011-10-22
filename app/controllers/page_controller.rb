class PageController < InheritedResources::Base
  layout 'application'
  def index
    if logged_in? and !current_user.login.empty?
      redirect_to profile_path(current_user.login) 
    elsif logged_in?
      redirect_to users_path(current_user)
    end
  end

  def help
  end

  def about
    @users = Array.new
    @resources_needed = Hash.new
    @resources_offered = Hash.new
    10.times do 
      randomUser = User.random
      @users.push(randomUser) if !@users.include?(randomUser)
    end
    @items_needed = Item.need
    @items_offered = Item.offer
    @itemTypes = ItemType.all
    
    getNeedsAndOffers("Item", @itemTypes)
    
    @goods = Item.good
    @services = Item.service
    @transports = Item.transport
    @sharingpoints = Item.sharingpoint
    @ideas = Item.idea
  end
end