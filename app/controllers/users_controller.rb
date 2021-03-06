class UsersController < InheritedResources::Base
	#load_and_authorize_resource
	actions :index, :show, :new, :create, :update

  protect_from_forgery :except => [:tag_suggestions]
  
  layout :conditional_layout
  respond_to :html, :xml, :json, :js
  helper :items, :pings, :friendships, :userdetails
  before_filter :authenticate_user!, :except => [:index]

  auto_complete_for :aim_list, :name
  
  # has_scope :all_friends

  def index
		if params[:within].present? && (params[:within].to_i > 0)
      @usersearch = User.active.near(request.location.city,params[:within]).search(params[:q])
    else
	    @usersearch = User.active.search(params[:q])
    end
    
		@users = @usersearch.result(:distict => true).paginate(:page => params[:page]).order('id DESC')
    @users_count = @usersearch.result.count 
    @keywords = params[:q][:title_contains].to_s.split if params[:q] and not params[:q][:title_contains].blank?
    
    searchByTag(params, "User", @tagtype)
  	@searchItemType = "User"
    index!
  end
  
  def search
    index
    render :index
  end
  
  def show
    @message = current_user.sent_messages.build if logged_in?
    if params[:user_id]
      @user = User.find(params[:user_id], :include => [:location, :userdetails, :pings])
    else
      @user = User.find(params[:id], :include => [:location, :userdetails, :pings])
    end
    if @user
      @user.userdetails ||= Userdetails.new
      @itemTypes = ItemType.all
      @followings = @user.all_following
      @followings_count = @followings.size
      @followers = @user.followers(User)
      @followers_count = @followers.size

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
				impressionist(@user)
        @audits = Audit.where( :user_id => @user.id)
      end
      @audits = @audits.sort_by(&:created_at).reverse
    end

		@page_title = @user.login unless @user.login.blank?
  end

	def register_completion
		flash[:notice] = I18n.t("devise.confirmations.notYetConfirmed") 
	end

	def edit 
		@user = current_user
	end

	def update
		if params[:user][:is_active] && params[:user][:is_active].to_i < 1
			current_user.lock_access!
			redirect_to root_path
		else
			update!
		end
	end

	def destroy
	  User.find(params[:id]).destroy
	  flash[:notice] = t("flash.user.destroy.notice")
    redirect_to root_path
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

  # def follow
  #   @user = User.find(params[:id])
  #   if current_user.following?(@user)
  #     flash[:notice] = t("flash.users.follow.error.alreadyFollowing")
  #   else
  #     current_user.follow(@user)
  #     flash[:notice] = t("flash.users.follow.notice", :title => @user.login)
  #   end

  #   redirect_to(@user)
  # end

  def block
    @follower = User.find(params[:id])
    if current_user.block(@follower)
      flash[:notice] = t("flash.users.block.notice", :title => @follower.login)
    else
      flash[:error] = t("flash.users.block.error", :title => @follower.login)
    end
    redirect_to followers_user_path(current_user)
  end

  def unblock
    @follower = User.find(params[:id])
    @follow = Follow.find(:first, :conditions => {
        :follower_id => @follower.id,
        :followable_id => current_user.id,
        :followable_type => "User",
    })
    if @follow.update_attributes(:blocked => 0)
      flash[:notice] = t("flash.users.unblock.notice", :title => @follower.login)
    else
      flash[:error] = t("flash.users.unblock.error", :title => @follower.login)
    end
    redirect_to followers_user_path(current_user)
  end

  def followings
    @user = User.find(params[:id])
    @active_menuitem_l1 = I18n.t "menu.user.followings"
    @active_menuitem_l1_link = followings_user_path
    @followings = @user.all_following
    @following_users = @user.following_users
    @following_items = @user.following_items
    @following_groups = @user.following_groups
  end

  def followers
    @user = User.find(params[:id])
    @active_menuitem_l1 = I18n.t "menu.user.followers"
    @active_menuitem_l1_link = followers_user_path
    @followers = @user.followers(User)
    #@blocked_users = @user.blocks
  end

  private
    
  def prepare_search
    #searchlogic scopes
    $scope = User.prepare_search_scopes(params)
  end
  
  protected
   
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
