class UsersController < InheritedResources::Base

  protect_from_forgery :except => [:tag_suggestions]
  
  layout :conditional_layout
  respond_to :html, :xml, :json, :js
  helper :items, :pings, :friendships, :userdetails
  before_filter :authenticate_application_user!, :only => [:edit]

  auto_complete_for :aim_list, :name
  
  # has_scope :all_friends

  def index
    params[:search] = params[:q]
    @usersearch = User.search(params[:search])
    @users = @usersearch.result(:distict => true).paginate(:page => params[:page])
    @users_count = @usersearch.result.count 
    @keywords = params[:search][:title_contains].to_s.split if params[:search] and not params[:search][:title_contains].blank?
    
    if params[:aim]
      @tag = params[:aim]
      @tagtype = "aim"
    elsif params[:wish]
      @tag = params[:wish]
      @tagtype = "wish"
    elsif params[:interest]
      @tag = params[:interest]
      @tagtype = "interest"
    end
    taggedUsers(@tag) if @tag
    
    index!
  end
  
  def search
    index
    render :index
  end
  
  def show
    if params[:user_id]
      @user = User.find(params[:user_id], :include => [:location, :userdetails, :pings])
    else
      @user = User.find(params[:id], :include => [:location, :userdetails, :pings])
    end
    if @user
      @user.userdetails ||= Userdetails.new
      @itemTypes = ItemType.all
      @followings = @user.all_following
      @followers = @user.followers

      if current_user == @user
        @inverse_audits = Array.new
        @followings.each do |following|
          case following.class.to_s
          when "User"
            @inverse_audits << Audit.where( :user_id => following.id ).all
          when "Item"
            @inverse_audits << Audit.where( :auditable_id => following.id ).all
          end
        end
        if @inverse_audits.size > 0
          @audits = Audit.where( :user_id => @user.id)  + @inverse_audits.flatten!
        else
          @audits = Audit.where( :user_id => @user.id)
        end
      else
        @audits = Audit.where( :user_id => @user.id)
      end
      @audits = @audits.sort_by(&:created_at).reverse
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
  
  def confirm
    self.current_user = params[:confirmation_token].blank? ? false : User.find_by_activation_code(params[:confirmation_token])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = t("flash.users.activate.notice")
    end
    # redirect_to ('users')
    redirect_to :controller => "users", :action => "show", :id => current_user.id
  end

  def follow
    @user = User.find(params[:id])
    if current_user.following?(@user)
      flash[:notice] = t("flash.users.follow.error.alreadyFollowing")
    else
      current_user.follow(@user)
      flash[:notice] = t("flash.users.follow.notice", :title => @user.login)
    end

    redirect_to(@user)
  end
 
  private
    
  def prepare_search
    #searchlogic scopes
    $scope = User.prepare_search_scopes(params)
  end
  
  protected
   
  def taggedUsers(tag)
    @usersearch = User.tagged_with(tag).search(params[:search])
    @users, @users_count = @usersearch.result.paginate(:page => params[:page]), @usersearch.result.count
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
