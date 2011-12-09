class MeetupsController < InheritedResources::Base

  layout :conditional_layout
  respond_to :html, :xml, :json
#  before_filter :login_required
  
  def index 
    @user = current_user
    @meetups = @user.meetups if @user 
    @active_menuitem_l1 = I18n.t "menu.user.meetups" 
    @active_menuitem_l1_link = polymorphic_path([@user, :meetups])
    index!
  end
  
  def show
    @user = current_user 
    @meetup = @user.meetups.find(params[:id])
    getLocationsOnMap(@meetup.locations, @meetup.title, "/images/icons/icon_meetup.png")
    show!
  end  
  
  
  def new
    if params[:event]
      @eventable_id = params[:event][:eventable_id]
      @eventable_type = params[:event][:eventable_type]
      @ping = Ping.find(params[:event][:ping])
      @class = Kernel.const_get(@eventable_type) # get the classname out of a string
      @thing = @class.find(@eventable_id)
    end
    @user = current_user
    @users = User.all
    @meetup = Meetup.new
    @meetup.locations.build 
    @meetup.events.build
  end
  
  def create
    @user = current_user       
    @eventable = find_model
    @meetup = Meetup.new(params[:meetup])
    @meetup.locations.build if @meetup.locations.size == 0 
    @meetup.events.build if @meetup.events.size == 0
    create!
  end
  
  def edit
    @user = current_user
    @eventable_type = "Meetup"
    @eventable_id = params[:id]
    @eventable = find_model
    @meetup = Meetup.find(params[:id])
    
    if @meetup.locations.size == 0       
      @locatable = find_model
      @location = @meetup.locations.build
    else                          
      @location = @meetup.locations.first
      getLocationsOnMap(@location, I18n.t("resources.location"), "/images/icons/icon_meetup.png")
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
  
  def conditional_layout
    case action_name
      when "index" then "userarea"
      else "userarea"
    end
  end

 end
