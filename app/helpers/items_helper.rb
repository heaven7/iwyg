module ItemsHelper
 
  def itemImage(item)
    if item.images.first
      image_tag item.images.first.image.url(:tiny)
    end
  end
  
  def itemTinyThumb(item)
    if item.images.first
      image_tag item.images.first.image.url(:tiny)
    end
  end
  
  def itemSmallThumb(item)
    if item.images.first
      image_tag item.images.first.image.url(:small)
    end
  end
  
	def showDistanceOfSearcher(item)
		itemlocation = item.locations.first if item.locations.size > 0
		userlocation = params[:near] || request.location.city
		if userlocation and itemlocation
			distance = itemlocation.distance_to(userlocation)		 
			if distance.class.to_s == "Float" 
				return number_with_precision(distance, :precision => 2) + " km" if distance.to_s != "NaN"
			end
		end
		nil
	end
    
  def transferStatus(item, ping)
    @transfer = Transfer.find_by_transferable_id_and_receiverable_id(item.id, ping.user_id)
    if @transfer
      case @transfer.status
      when 1 # open
        @status = Status.find(@transfer.status).title
        @username = User.find(@transfer.user_id).login
      when 2,3 # accepted, declined
        @status = Status.find(@transfer.status).title
        @username = User.find(ping.user_id).login
      end
      link_to t("transfer.status", :status => t(@status), :user => @username), @transfer, :class => @status
    end
  end
  
  def eventStatus(item, ping)
    @event = Event.find_by_eventable_id_and_ping_id(item.id, ping.id)
    if @event
      @status = Status.find(@event.status).title
      case @event.status
      when 1 # open
        @username = User.find(@event.user_id).login
      when 2,3 # accepted, declined
        @username = User.find(ping.user_id).login
      end
      link_to t("event.status", :status => t(@status), :user => @username), @event, :class => @status
    end
  end

  
  def itemType_by_id(id)
    ItemType.find(id).title.to_s
  end
  
  
  def owner(item)
		owner = item.itemable
		if owner
			case owner.class.to_s
			when "User"
				title = owner.login
			else
				title = owner.title 
			end
		else
			nil	
		end
  end
  
  def holderTinyThumb(item)
    if item.user_id    
      @user = User.find(item.user_id, :include => [:images])
      if @user.images.first
        @user.images.first.image.url(:tiny)
      else
        '/images/global/avatar_dummy_thumbnail.png'
      end
    end
  end
  
  def holderSmallThumb(item)
    @user = User.find(item.user_id, :include => [:images])
    @user.images.first.image.url(:tiny)
  end
  
  def is_need?(item)
    if item.need?
      "needs"
    else
      "offers"
    end
  end
  
  def is_needed?(item)
    if item.need?
      "needed"
    else
      "offered"
    end
  end
  
  # add images to item
  def add_images_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :images, :partial => 'image' , :object => Image.new
    end
  end

end
