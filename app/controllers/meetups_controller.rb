class MeetupsController < InheritedResources::Base

  layout :conditional_layout
  respond_to :html, :xml, :json
  #  before_filter :login_required
  
  def index 
    @user = User.find(params[:user_id]) if params[:user_id]
    if @user
      @meetups = @user.meetups
      @active_menuitem_l1 = I18n.t "menu.user.meetups"
      @active_menuitem_l1_link = polymorphic_path([@user, :meetups])
      render :layout => "userarea"
    else
      @meetups = Meetup.all
      index!
    end
  end
  
  def show
    @user = current_user 
    if params[:user_id]
      @meetup = @user.meetups.find(params[:id], :conditions => { :foreign_key => "owner_id"})
    else
      @meetup = Meetup.find(params[:id])
    end
    getLocationsOnMap(@meetup)
    show!
  end  
  
  
  def new

    @user = current_user
    @active_menuitem_l1 = I18n.t "menu.user.meetups" 
    @active_menuitem_l1_link = polymorphic_path([@user, :meetups])
    @meetup = Meetup.new
    @meetup.locations.build 
    @meetup.events.build

    if params[:item]
      @attachable_id = params[:item][:attachable_id]
      @ping = Ping.find(params[:item][:ping])
      @item = Item.find(@attachable_id)
      @meetup.users = Array[current_user, @ping.owner]
    else
      @meetup.users = @user.followers
      @meetup.users << @user.following_users
    end
  end
  
  def create
    @user = current_user 
    @eventable = find_model
    @meetup = Meetup.new(params[:meetup])
    @users = User.all
    @meetup.locations.build if not @meetup.locations.size == 0
    @meetup.events.build if @meetup.events.size == 0
    # create!
   
    if @meetup.save
      redirect_to @meetup
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
    @eventable_type = "Meetup"
    @eventable_id = params[:id]
    @eventable = find_model
    @meetup = Meetup.find(params[:id])
    @users = User.all
    if @meetup.locations.size == 0       
      @locatable = find_model
      @location = @meetup.locations.build
    else                          
      getLocationsOnMap(@meetup)
    end
    
    if @meetup.events.size == 0
      @event = @meetup.events.build
    else 
      @event = @meetup.events.first
    end
    edit!
  end
  
  
  
  def update  
    @user = current_user
    update!
  end
  

  
  private
  
  def getLocationsOnMap(object)
    @locations_json = object.locations.to_gmaps4rails
  end 
  
  def conditional_layout
    case action_name
    when "index" then "application"
    else "userarea"
    end
  end

end
