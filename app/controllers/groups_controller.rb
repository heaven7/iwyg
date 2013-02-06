class GroupsController < InheritedResources::Base
  protect_from_forgery :except => [:tag_suggestions]
  layout :conditional_layout

  respond_to :html, :xml, :js, :json
  before_filter :authenticate_user!, :except => [:index]
	before_filter :updateNotifications, :only => [:show]
  
  def index
    params[:search] = params[:q] if params[:q]
    
    if params[:user_id]
      @user = User.find(params[:user_id])
      
      if @user.groups and @user.groups.size > 0
        @groups = @user.groups.paginate(
          :page => params[:page],
          :per_page => PINGS_PER_PAGE,
          :order => "created_at DESC"
        )
      end
      # get all groups with membership of current_user
      @memberships = Array.new
      Group.all do |group|
        members = group.users
        @memberships << group if group.users.include?(@user)
      end
      @active_menuitem_l1 = I18n.t "menu.main.groups"
      @active_menuitem_l1_link = user_groups_path
      render :layout => 'userarea'
    elsif params[:search] && params[:search][:tag]
      # search by tag    
      @groups = searchByTag(params, "Group")
    else
      @groups = Group.paginate(
        :page => params[:page],
        :per_page => PINGS_PER_PAGE,
        :order => "created_at DESC"
      )    
    end 
  	@searchItemType = "Group"
    @groups_count = @groups.size if @groups
  end

  def new
    @user = current_user
    @group = Group.new
    @group.locations.build
    @active_menuitem_l1 = I18n.t "menu.main.groups"
    @active_menuitem_l1_link = user_groups_path

		groupUsers
  end

  def edit
    @user = current_user
    @group = Group.find(params[:id])
    @location = @group.locations.first || @group.locations.build
    @active_menuitem_l1 = I18n.t "menu.main.groups"
		#@locations_json = @location.to_gmaps4rails		

		groupUsers
  end

  def show
    if params[:user_id]
      @user = User.find(params[:user_id])
      @group = @user.groups.find(params[:id])
    else
      @group = Group.find(params[:id])
    end 
		@members_pending = @group.members_pending
		@members = @group.members

		# check if current_user is invited
		@invitation = @group.groupings.pending.where(:owner_id => nil, :user_id => current_user).first if current_user
		# check if current_user is member
		@membership = @group.groupings.accepted.where(:user_id => current_user).first if current_user
		# check if current_user requested membership
		@request = @group.groupings.pending.where(:user_id => current_user, :owner_id => current_user).first if current_user

		@items_offered = @group.items.offered
    @items_needed = @group.items.needed
		@used_resources = Item.where('accounts.accountable_id' => @group.id, 'accounts.accountable_type' => "Group")
    @items_taken = @used_resources.taken 
    @items_given = @used_resources.given

    # friendly_id outdated finder statuses
    #if request.path != group_path(@group)
    #  return redirect_to @group, :status => :moved_permanently
    #end
    @location = @group.locations.first if @group.locations && @group.locations.first
    getLocationsOnMap(@group) if @location and not @location.lat.nil? and not @location.lng.nil?

		impressionist(@group)
  end

  def create
    @user = current_user
    @active_menuitem_l1 = I18n.t "menu.main.groups"
    @location = Location.new(params[:locations_attributes]) if params[:locations_attributes]
    @image = Image.new(params[:images_attributes]) if params[:images_attributes]
    create!
  end

  def update
    @group = Group.find(params[:id])
    # gropu.images = Image.new(params[:group][:images_attributes])
    if @group.update_attributes(params[:group])
      flash[:notice] = t("flash.groups.update.notice")
      redirect_to @group
    else
      render :action => 'edit'
    end
  end

  def follow
    @group = Group.find(params[:id])
    if current_user.following?(@group)
      flash[:notice] = t("flash.groups.follow.error.alreadyFollowing")
    else
      current_user.follow(@group)
      flash[:notice] = t("flash.groups.follow.notice", :title => @group.title)
    end

    redirect_to(@group)
  end

  def tag_suggestions
    @tags = Group.tag_counts_on("tags").find(:all, :conditions => ["name LIKE ?", "%#{params[:term]}%"], :limit=> params[:limit] || 5)
    render  :json => @tags.join(',').split(',')
  end


  protected


	def groupUsers
		@users = @user.followers + @user.following_users - @group.members
	end

  def conditional_layout
    case action_name
    when "new", "edit", "create", "update" then "userarea"
    else "application"
    end
  end

end
