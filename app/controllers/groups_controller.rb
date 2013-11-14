class GroupsController < InheritedResources::Base
  protect_from_forgery :except => [:tag_suggestions]
  layout :conditional_layout

  respond_to :html, :xml, :js, :json
  before_filter :authenticate_user!, :except => [:index]
	before_filter :updateNotifications, :only => [:show]
  
  def index
    
    @groupsearch = Group.search(params[:q])
    
		# get all groups with membership of current_user
    if params[:user_id]
      @user = User.find(params[:user_id])
      @memberships = Array.new
      Group.all do |group|
        members = group.users
        @memberships << group if group.users.include?(@user)
      end
      @active_menuitem_l1 = I18n.t "menu.main.groups"
      @active_menuitem_l1_link = user_groups_path

      if @user.groups and @user.groups.size > 0		
	     @groupsearch = @user.groups.search(params[:q]) 
      end
      
      render :layout => 'userarea'

    # search by tag    
    elsif params[:q] && params[:q][:tag]
      @groupsearch = searchByTag(params, "Group").search(params[:q])
    end 

		# search within certain range
		@groupsearch = searchByRangeIn("Group") if params[:within]

		# pagination
		@groups = @groupsearch.result(:distict => true).paginate(
      :page => params[:page],
      :per_page => AppSettings.groups.per_page,
      :order => "created_at DESC"
    )   
    @groups_count = @groupsearch.result.count
  	@searchItemType = "Group"
  end

  def new
    @user = current_user
    @group = Group.new
    getJSonLocation(@group)
    @group.locations.build
    @active_menuitem_l1 = I18n.t "menu.main.groups"
    @active_menuitem_l1_link = user_groups_path

    # load default settings into form
    @setting_visible_for = AppSettings.group.visible_for.default

		groupUsers
  end

  def edit
    @user = current_user
    @group = Group.find(params[:id])
    getJSonLocation(@group)
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

		@page_title = @group.title unless @group.title.blank?
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

  def tag_suggestions
    @tags = Group.tag_counts_on("tags").find(:all, :conditions => ["name LIKE ?", "%#{params[:term]}%"], :limit=> params[:limit] || 5)
    render  :json => @tags.join(',').split(',')
  end


  protected


	def groupUsers
		#@users = @user.followers + @user.following_users - @group.members
    @users = @group.members
  
	end

  def conditional_layout
    case action_name
    when "new", "edit", "create", "update" then "userarea"
    else "application"
    end
  end

end
