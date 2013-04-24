class PageController < InheritedResources::Base
  layout 'application'
  def index
    if logged_in? 
      redirect_to current_user
    end
  end

  def help
  end

	def agb
	end

	def privacypolicy
	end

	def imprint
	end

  def about
    @users = Array.new
    @resources_needed = Hash.new
    @resources_offered = Hash.new
    10.times do 
      randomUser = User.random
      @users.push(randomUser) if !@users.include?(randomUser)
    end
    @items_needed = Item.needed
    @items_offered = Item.offered
    @itemTypes = ItemType.all
    
    getNeedsAndOffers("Item", @itemTypes)
    
    @goods = Item.good
    @services = Item.service
    @transports = Item.transport
    @sharingpoints = Item.sharingpoint
    @ideas = Item.idea
  end
end
