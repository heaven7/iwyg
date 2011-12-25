class GroupsController < InheritedResources::Base
  protect_from_forgery :except => [:tag_suggestions]

  layout :conditional_layout
  respond_to :html, :xml, :js, :json
  before_filter :authenticate_user!, :only => [:new, :edit, :create]
  
  def index
    if params[:user_id]
      @user = current_user
      @groups = @user.groups.paginate(
        :page => params[:page],
        :per_page => PINGS_PER_PAGE,
        :order => "created_at DESC"
      )    
      @active_menuitem_l1 = I18n.t "menu.main.groups"
      @active_menuitem_l1_link = user_groups_path
      render :layout => 'userarea'
    else
      @groups = Group.all.paginate(
        :page => params[:page],
        :per_page => PINGS_PER_PAGE,
        :order => "created_at DESC"
      )    
    end 
  end

  def new
    @user = current_user
    @group = Group.new
    @active_menuitem_l1 = I18n.t "menu.main.groups"
    @active_menuitem_l1_link = user_groups_path
  end

  def edit
    @user = current_user
    @group = Group.find(params[:id])
    @active_menuitem_l1 = I18n.t "menu.main.groups"
    @active_menuitem_l1_link = user_groups_path
  end

  def tag_suggestions
    @tags = Group.tag_counts_on("tags").find(:all, :conditions => ["name LIKE ?", "%#{params[:term]}%"], :limit=> params[:limit] || 5)
    render  :json => @tags.join(',').split(',')
  end


  protected

  def conditional_layout
    case action_name
      when "new", "edit" then "userarea"
      else "application"
    end
  end

end
