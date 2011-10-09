class UsersController < InheritedResources::Base

  protect_from_forgery :except => [:tag_suggestions]
  
  layout :conditional_layout
  respond_to :html, :xml, :json, :js
  helper :items, :pings, :friendships, :userdetails
  before_filter :authenticate_application_user!, :only => [:edit]

  auto_complete_for :aim_list, :name
  
  # has_scope :all_friends

  def index
     if params[:search]
      prepare_search                                  
      @usersearch = User.search(params[:search]) 
      @users, @users_count = $scope.paginate(:page => params[:page]), $scope.count       
    else
      @usersearch = User.search(params[:search])
      @users = @usersearch.paginate(:page => params[:page])
      @users_count = @usersearch.count 
    end
    
    if params[:aim]
      @tag = params[:aim]
      @tagtype = "aim"
    elsif params[:wish]
      @tag = params[:wish]
      @tagtype = "wish"
    elsif params[:interest]
      @tag = params[:interest]
      @tagtype = "interest"
    elsif params[:skill]
      @tag = params[:skill]
      @tagtype = "skill"
    end
    taggedUsers(@tag) if @tag
    
    index!
  end
  
  def show
    if params[:login]
      @user = User.find_by_login(params[:login])
    elsif params[:user_id]
      @user = User.find(params[:user_id], :include => [:location, :userdetails, :pings])
    else
      @user = User.find(params[:id], :include => [:location, :userdetails, :pings])
    end
    if @user
      @user.location ||= Location.new()
      @user.userdetails ||= Userdetails.new 
      @itemTypes = ItemType.all
      #@user.avatar ||= Avatar.new 
    end
  end

  
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = t("flash.users.create.notice")
    else
      render :action => 'new'
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = t("flash.users.activate.notice")
    end
    # redirect_to ('users')
    redirect_to :controller => "users", :action => "show", :id => current_user.id
  end
 
  private
    
  def prepare_search
    #searchlogic scopes
    $scope = User.prepare_search_scopes(params)
  end
  
  protected
   
  def taggedUsers(tag)
    @usersearch = User.tagged_with(tag).search(params[:search])
    @users, @users_count = @usersearch.all.paginate(:page => params[:page]), @usersearch.count
  end
   
  def collection 
    @users ||= end_of_association_chain.paginate(
      :page => params[:page],
      :per_page => 1,
      :order => "created_at ASC"
    )
  end
  
  def conditional_layout
    case action_name
      when "index", "new", "create" then "application"
      else "userarea"
    end
  end

end
