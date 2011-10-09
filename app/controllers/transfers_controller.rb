require 'geokit'
class TransfersController < InheritedResources::Base
  
  layout :conditional_layout
  respond_to :html #, :xml, :json
  belongs_to :transferable, :polymorphic => true
  
  before_filter :login_required, :exept => [:index, :show]
  
  has_scope :open
  has_scope :non_open
  has_scope :accepted
  has_scope :declined
  has_scope :closed

  
  def index
    @transferable = find_transferable
    if @transferable.class.to_s == "User"
      @user = User.find(params[:user_id])
      @transfers = @user.transfers.not_closed.paginate(
        :page => params[:page],
        :per_page => TRANSFERS_PER_PAGE,
        :order => "created_at DESC"
      )
      @inverse_transfers = Array.new
      Transfer.all.each do |t|
        @inverse_transfers << t if t.pinger == @user.id && t.status < 4
      end   
      @inverse_transfers.flatten!
      @inverse_transfers.paginate(
        :page => params[:page],
        :per_page => TRANSFERS_PER_PAGE,
        :order => "created_at DESC"
      )
    else
      @transfers = Transfer.not_closed.find(:all, :order => "transfers.created_at DESC" ).paginate(
        :page => params[:page],
        :per_page => TRANSFERS_PER_PAGE,
        :order => "created_at DESC"
      )
    end
  end
  
  
  def show
  
    @transferable = find_transferable
    
    @transfer = Transfer.find(params[:id], :include => [ :comments ])
    @resource = @transfer.item
    @receiver = User.find(@transfer.pinger)
    @comments = @transfer.comments.find(:all, :order => "created_at DESC")
    @user = User.find(@transfer.user_id) || User.find(params[:user_id])
    @breakpoint = @transfer.getReceiverType
    initMap
    
    if @resource.need?
      buildRoute(@map, @receiver, @resource)
    else
      buildRoute(@map, @resource, @receiver) 
    end
    
    # chosen action of pinger
    case @transfer.transferable_type.to_s
      when "Item"
        # user bring item to receiver by itself
        if @transfer.item.owner == @receiver
        
        end
        # user bring item to sharingpoint
        
      when "User"
        # user bring item to another user
    end
    
    if @transfer.transferable_type.to_s == "User" and @breakpoint
      makeIcon(@map, @breakpoint, "usericon")
    elsif @breakpoint
      makeIcon(@map, @breakpoint, "sharingpoint")
    end
    
  end
  
  
  
  def new
    @transferable = find_transferable
    @transferable_type = params[:transferable_type].to_s
    initMap
    
    case @transferable_type
    when "Item"
      @item = Item.find(params[:transferable_id])
      
      # set Route
      if @item.need?
        @pinger = current_user 
        @user = @item.owner
        buildRoute(@map, @pinger, @item)
      else
        @pinger = User.find(params[:pinger])
        @user = current_user
        buildRoute(@map, @item, @pinger)
      end
      
      # get Transferoptions
      case @item.itemtype.downcase
        when "good"
         getOptionsOf(TransferOptions.good) 
        when "idea"
        when "service"
        when "transport"
        when "sharingpoint"
      end
      
      setupMap(@item, @pinger)
      
    when "User"  
    end 

    @transfer = @user.transfers.new
  end
  
  
  
  
  def edit
    @user = current_user
    @transfer = @user.transfers.find(params[:id])
    @item = Item.find(@transfer.transferable_id)
    @pinger = User.find(@transfer.pinger)
  end
  
   
  
  
  def create
    
    @transferable = find_transferable
    @transfer = @transferable.transfers.build(params[:transfer])
    @item = Item.find(@transfer.transferable_id)
    @pinger = User.find(@transfer.pinger)
    
    if @item.multiple? and Transfer.exists?(params[:transfer][:transferable_id], @transfer.transferable_type.to_s, params[:transfer][:user_id])
      
      flash[:error] = "You cannot set more than one transfers on this #{@transfer.transferable_type}!"
      redirect_to [@transferable]
      
    elsif @transfer.save
      
      # set item status to on transfer
      @item.update_attribute(:status, 4)
      flash[:notice] = "Transfer has been set."
      if @transferable
        redirect_to [@transferable, @transfer]
      else
        redirect_to @transfer
      end
      
    else
      render :action => 'new'
    #  create!
    end
  end
  
  
  
  def update
    @transfer = Transfer.find(params[:id])
    if @transfer.update_attributes(params[:transfer])
      flash[:notice] = "Successfully updated transfer."
      redirect_to @parent_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @transfer = Transfer.find(params[:id])
    @transfer.destroy
    flash[:notice] = "Successfully destroyed transfer."
    redirect_to parent_url
  end
  
  
  
  # on a acception the transfered resource is now owned by
  # acceptor, former owner will be noticed about that.
  # also if a user has given or has taken something, will
  # be taken into account.
  
  def accept
    @transfer = Transfer.find(params[:id])
    @transferable = @transfer.transferable_type
    @resource = @transferable.classify.constantize.find(@transfer.transferable_id)
    @transferer = User.find(@transfer.user_id)
    @holder = User.find(@resource.user_id)
    @receiver = User.find(@transfer.pinger)
    
    if current_user == @receiver
      if @transfer.status.to_i == 2
          flash[:error] = 'This transfer is accepted already!'
      else
        # accept transfered item (transfer)
        @transfer.update_attributes(:status => 2, :accepted_at => Time.now)
        
        case @transferable
          when "Item"
          
            if @resource.multiple == false
              
              # close other pings on that resource
              @resource.pings.each do |p|
                p.update_attributes('status' => 4) 
              end 
              
              # close transfer
              @transfer.update_attributes(:status => 4)
              
              # transfer resource to receiver and set resource inactive (not pingable)
              @resource.location = @receiver.location
              @resource.update_attributes(:status => 5, :user_id => @receiver.id)
              
              if @resource.save
                flash[:notice] = "You accepted. This '#{@resource.title}' is now holded by you!"
              end
              
            else
              flash[:notice] = "You accepted: '#{@resource.title}'"
            end
          else
            flash[:notice] = "You accepted the #{@transferable}."
        end 
        
        # accounting
        makeAccounting(@resource,@holder,@receiver)
        
      end
    else
      flash[:error] = 'You are not allowed to accept' 
    end
    redirect_to @resource
  end
  
  
  
  def decline
    @transfer = Transfer.find(params[:id])
    @transferable = @transfer.transferable_type
    @resource = @transferable.classify.constantize.find(@transfer.transferable_id)
    @transferer = User.find(@transfer.user_id)
    @holder = User.find(@resource.user_id)
    @receiver = User.find(@transfer.pinger)
    
    if current_user == @receiver
      if @transfer.status.to_i == 2
        flash[:error] = 'This transfer is accepted already and therefore you cannot decline it!'
      elsif @transfer.status.to_i == 3
        flash[:error] = 'This transfer is declined already!'
      else
        # decline transfered item (transfer)
        @transfer.update_attributes(:status => 3)
        flash[:notice] = "This #{@transferable} is now declined by you!"
      end
    else
      flash[:error] = 'You are not allowed to decline!' 
    end
    redirect_to @resource
  end 
  
  private

  def find_transferable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
  
  def getOptionsOf(options)
    @options = Array.new
     c = 1
     options.each do |option|
      @options.push([I18n.translate(option.title), c])
      c +=1
     end
  end
  
  def initMap
    @map = GMap.new("map")
    @map.control_init(:large_map => true,:map_type => true)  
  end
  
  def setupMap(item, pinger)
    #item.location = item.location || item.owner.location
    @users = Array.new
    @friends = Array.new
    @sharingpoints = Array.new
    startpoint = [item.location.lat,item.location.lng]
    endpoint = [pinger.location.lat, pinger.location.lng]
    midpoint = item.location.midpoint_to(pinger.location)
   # locations = Location.find(:all, :bounds =>[startpoint, endpoint]) if startpoint && endpoint
    locations = Location.find(:all, :origin => midpoint)
    if locations && locations.size > 0
      locations.each do |location|
        
        # get all sharingpoints inbetween start- and endpoint
        Item.sharingpoint.each do |sharingpoint|
          @sharingpoints << sharingpoint if sharingpoint.location == location
        end
        
        # get all friends inbetween start- and endpoint
        current_user.friends.each do |user|
          @friends << user if user.location == location
        end
        
        # get all users inbetween start- and endpoint  
        User.all.each do |user|
          @users << user if user.location == location
        end
        
      end # each
    end # if
    
  end
  
  def makeAccounting(resource, holder, receiver)
    
    if resource.need == 1
      # holder has taken
      holder_has_taken = 1
      # receiver has given
      receiver_has_taken = 0
    else
      # holder has given
      holder_has_taken = 0
      # receiver has taken
      receiver_has_taken = 1
    end
    
    holder.accounts.build(
      :item_id => resource.id,
      :user_id => holder,
      :has_taken => holder_has_taken,
      :created_at => Time.now
    ).save
    
    receiver.accounts.build(
      :item_id => resource.id,
      :user_id => receiver,
      :has_taken => receiver_has_taken,
      :created_at => Time.now
    ).save
    
  end
  
  
  def buildRoute(map, startpoint, endpoint)
    if startpoint.location.lat and startpoint.location.lng
    
      @address_from = "#{startpoint.location.lat},#{startpoint.location.lng}" 
      @address_to = "#{endpoint.location.lat},#{endpoint.location.lng}"
      map.directions('panel', [@address_from, @address_to])
    
      @distance = startpoint.location.distance_from(endpoint.location, :units =>:kms)
          
      # startpoint icon
      makeIcon(map, startpoint, "startpoint")     
      
      # endpoint icon
      makeIcon(map, endpoint,"usericon") 
      
      # sharingpoints in between
      #showSharingpointsInBetween(map, startpoint, endpoint)
      
      # midpoint & zoom
      @midpoint = startpoint.location.midpoint_to(endpoint.location)
      map.center_zoom_init([@midpoint.lat, @midpoint.lng], (@distance/100).round )
    end
  end
  
  protected
    
  def conditional_layout
    case action_name
      when  "show", "new", "create" : "application"
      when "index"
        if @user then "userarea"
        else "application" end
      else "userarea"
    end
  end
  
  def showSharingpointsInBetween(map, sender, receiver)
    # build bounds and show nearby sharingpoints
    points = Array.new
    points[0] = [sender.location.lat,sender.location.lng]
    points[1] = [receiver.location.lat,receiver.location.lng]
    @bounds = GBounds.new(points)
    @sharingpoints = Array.new
    Item.sharingpoint.each do |sharingpointitem|
       if sharingpointitem.location.lat and sharingpointitem.location.lng
         sharingpointlocation = Array.new([sharingpointitem.location.lat, sharingpointitem.location.lng])
         if @bounds.contains?(sharingpointlocation)
           makeIcon(map,sharingpointitem, "sharingpoint")
         end
      end
    end
  end
  
  def makeIcon(map, resource, iconname)
  
    case resource.class.to_s
    when  "Item"
      image = "/images/icons/icon_#{resource.itemtype.downcase}.png"
      title = resource.title
    when "User"
      image = "/images/icons/icon_user.png"
      title = resource.login
    end
    city = resource.location.city if resource.location.city
    country = resource.location.country if resource.location.country
  
    icon = Variable.new(iconname)
    map.icon_global_init(
      GIcon.new(
        :image => image,
        :info_window_anchor => GPoint.new(9,2),
        :icon_anchor => GPoint.new(7,7)
      ),
      iconname
    )
    resourcelocation = GMarker.new([resource.location.lat,resource.location.lng], 
      :icon => icon,
      :title => "#{title}, #{city}", 
      :info_window => "<h2><a href=\"#{resource_path(resource)}\">#{title}</a></h2><div class=\"image\"><a href=\"#{resource_path(resource)}\"><img src=\"#{resource.images.first.image.url(:tiny) if resource.images.first}\" alt=\"#{title}\" title=\"#{title}\" /></a></div>#{city}, #{country}"
    )
    map.overlay_init(resourcelocation) 
  end
  
  
end
