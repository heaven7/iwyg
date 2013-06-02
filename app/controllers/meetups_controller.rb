class MeetupsController < InheritedResources::Base

  layout :conditional_layout
  respond_to :html, :xml, :json
  before_filter :authenticate_user!
  
  def index 
    @user = User.find(params[:user_id]) if params[:user_id]
    if @user
      @meetups = Meetup.where(:owner_id => @user.id).all
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

	  @meeting = @meetup.find_by_meeting_user(current_user)
	  if @meetup.owner != current_user and @meeting and !@meeting.accepted_already? 
	    @acceptlink = self.class.helpers.link_to I18n.t("meetup.accept"), accept_meeting_path(@meeting), :method => :put
	  end
    show!
  end  
  
  
  def new

    @user = current_user
    @active_menuitem_l1 = I18n.t "menu.user.meetups" 
    @active_menuitem_l1_link = polymorphic_path([@user, :meetups])
    @meetup = Meetup.new
    getJSonLocation(@meetup)
    @meetup.locations.build 
    @meetup.events.build

    meetupUsers
  end
  
  def create
    @user = current_user 
    @eventable = find_model
    @meetup = Meetup.new(params[:meetup])
    getJSonLocation(@meetup)
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

    meetupUsers
    
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

	
	def like
    @meetup = Meetup.find(params[:id])
		likeOf(current_user, @meetup)
	end

	def unlike
    @meetup = Meetup.find(params[:id])
		likeOf(current_user, @meetup)
	end
  
  def accept

  end

  def decline

  end
  
  private

  def meetupUsers
    if params[:item]
      @attachable_id = params[:item][:attachable_id]
      @ping = Ping.find(params[:item][:ping])
      @item = Item.find(@attachable_id)
      @meetup.users = Array[@ping.owner]
    else
      @meetup.users = @user.followers
      @meetup.users << @user.following_users
    end
  end
  
  def conditional_layout
    case action_name
    when "index", "show" then "application"
    else "userarea"
    end
  end

end
