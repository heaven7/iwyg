class GroupsController < InheritedResources::Base

  layout :conditional_layout
  
  def index
    if params[:user_id]
      @user = current_user
      @groups = @user.groups
      @active_menuitem_l1 = I18n.t "menu.main.groups"
      @active_menuitem_l1_link = user_groups_path
      render :layout => 'userarea'
    else
      @groups = Group.all
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
  end

  protected

  def conditional_layout
    case action_name
      when "new", "edit" then "userarea"
      else "application"
    end
  end

end
