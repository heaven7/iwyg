class GroupsController < InheritedResources::Base
  protect_from_forgery :except => [:tag_suggestions]

  layout :conditional_layout
  respond_to :html, :xml, :js, :json
  before_filter :authenticate_user!, :only => [:new, :edit, :create]
  
  def index
    params[:search] = params[:q] if params[:q]
    
    if params[:user_id]
      @user = User.find(params[:user_id])
      @groups = @user.groups.paginate(
        :page => params[:page],
        :per_page => PINGS_PER_PAGE,
        :order => "created_at DESC"
      )    
      @active_menuitem_l1 = I18n.t "menu.main.groups"
      @active_menuitem_l1_link = user_groups_path
      render :layout => 'userarea'
    elsif params[:tag]
      # search by tag
      @tag = params[:tag]
      @tagtype = "tag"
      @groups = Group.tagged_with(@tag).search(params[:search]).result.paginate(
        :page => params[:page],
        :per_page => ITEMS_PER_PAGE,
        :order => "created_at DESC"
      )
      @groups_count = @groups.size
    else
      @groups = Group.paginate(
        :page => params[:page],
        :per_page => PINGS_PER_PAGE,
        :order => "created_at DESC"
      )    
    end 
  end

  def new
    @user = current_user
    @group = Group.new
    #    @group.locations.build
    @active_menuitem_l1 = I18n.t "menu.main.groups"
    @active_menuitem_l1_link = user_groups_path
  end

  def edit
    @user = current_user
    @group = Group.find(params[:id])
    #    if @group.images.size == 0
    #      @imageable = find_model
    #      @image = @group.images.build
    #    end
    #@location = @group.locations.first || @group.locations.build
    @active_menuitem_l1 = I18n.t "menu.main.groups"
    #@active_menuitem_l1_link = user_groups_path
  end

  def show
    if params[:user_id]
      @user = User.find(params[:user_id])
      @group = @user.groups.find(params[:id])
    else
      @group = Group.find(params[:id])
    end 
    if request.path != group_path(@group)
      redirect_to @group, status: :moved_permanently
    end   
    @location = @group.locations.first if @group.locations && @group.locations.first
    getLocationsOnMap(@group) if @location and not @location.lat.nil? and not @location.lng.nil?
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

  def conditional_layout
    case action_name
    when "new", "edit", "create", "update" then "userarea"
    else "application"
    end
  end

end
