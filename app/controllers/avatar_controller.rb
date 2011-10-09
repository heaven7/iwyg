class AvatarController < ImagesController

  before_filter :login_required
  
  def show
    @user = User.find(params[:user_id])
    @avatar = @user.avatar
  end
  
  def index
    #redirect_to_hub_url
  end

  def upload
    @title = "Change your Avatar"
    @user = User.find(session[:user_id])
    if param_posted?(:avatar)
      image = params[:avatar][:image]
      @avatar = Avatar.new(@user, image)
      if @avatar.save
       flash[:notice] = "Your avatar has been uploaded."
       #redirect_to hub_url
      else
       flash[:error] = "Something went wrong."
        #redirect_to hub_url
      end
    end
  end

  def delete
    user = User.find(session[:user_id])
    user.avatar.destroy
    flash[:notice] = "Your avatar has been deleted."
#    redirect_to hub_url
  end

end
