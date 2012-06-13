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
    @active_menuitem_l1 = I18n.t "menu.main.meetups"
    @active_menuitem_l1_link = polymorphic_path([@user, :meetups])
    @active_menuitem_l2 = @meetup.title
    @active_menuitem_l2_link = user_meetup_path(@meetup)
    show!
  end  
  
  
  def new

    @user = current_user
    @active_menuitem_l1 = I18n.t "menu.user.meetups" 
    @active_menuitem_l1_link = polymorphic_path([@user, :meetups])
    @meetup = Meetup.new
    @meetup.locations.build 
    @meetup.events.build

    meetupUsers
  end
  
  def create
    @user = current_user 
    @eventable = find_model
    @meetup = Meetup.new(params[:meetup])
    
   # meetupUsers

    @meetup.locations.build if @meetup.locations.size == 0
    @meetup.events.build if @meetup.events.size == 0

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

  def meetupUsers
    if params[:item]
      @attachable_id = params[:item][:attachable_id]
      @ping = Ping.find(params[:item][:ping])
      @item = Item.find(@attachable_id)
      @meetup.users = Array[current_user]
      @meetup.invited_users = Array[@ping.owner]
    else
      #@meetup.users = Array[current_user]
      @meetup.invited_users = @user.followers
      @meetup.invited_users << @user.following_users
    end
  end
  
  def conditional_layout
    case action_name
    when "index" then "application"
    else "userarea"
    end
  end

end
