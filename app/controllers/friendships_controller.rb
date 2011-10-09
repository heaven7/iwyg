class FriendshipsController < InheritedResources::Base

  actions :index, :create, :accept, :destroy

  layout 'userarea'
  before_filter :login_required, :except => [:index]
  
  has_scope :pending
  
  def index
    @user = User.find(params[:user_id])
  end
  

  
  def create
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    @user = current_user
    respond_to do |format|
      if @friendship.save
        flash[:notice] = t("flash.friendships.create.notice")
        format.html { redirect_to([@user, :friendships]) }
      else
        flash[:error] = t("flash.friendships.create.error")
        format.html { redirect_to(@user, :friendships) }
      end
    end
  end

  def accept
    @friendship = Friendship.find(params[:id])
    @user = User.find(@friendship.user_id)
    @friend = User.find(@friendship.friend_id)
    if !friends_already?(@user.id, @friend.id)
      @friendship.update_attributes(:accepted_at => Time.now)
      flash[:notice] = t("flash.friendships.accept.notice")
    else
      flash[:error] = t("flash.friendships.accept.error")
    end
    redirect_to ([@friend, :friendships])
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    flash[:notice] = t("flash.friendships.destroy.notice")
    redirect_to current_user
  end
  
  protected
  def friends_already?(user_id, friend_id)
    user = User.find(user_id)
    friend = User.find(friend_id)
    return true if user.friends.include?(friend) && friend.friends.include?(user)
    false
  end
end
