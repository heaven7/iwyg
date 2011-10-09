class UserdetailsController < InheritedResources::Base
  
  respond_to :html
  layout 'userarea'
  helper :users
  before_filter :login_required, :exept => [:index, :show]

  def index
    @user = User.find(params[:user_id])
    @userdetails = @user.userdetails

  end

  # GET /userdetails/1
  # GET /userdetails/1.xml
  def show
    @user = User.find(params[:user_id])
    @userdetails = @user.userdetails

  end

  # GET /userdetails/new
  # GET /userdetails/new.xml
  def new
    @user.current_user
    @userdetails = Userdetails.new
    
  end

  # GET /userdetails/1/edit
  def edit
    @user = current_user
    @userdetails = @user.userdetails
    getLocationOnMap(@user.location, I18n.t("resources.location"), "/images/icons/icon_user.png") if @user.location
    if @user.images.size == 0
      @imageable = find_imageable
      @image = @user.images.build
    end
    @location = @user.location
  end

  # POST /userdetails
  # POST /userdetails.xml
  def create
    @userdetails = Userdetails.new(params[:userdetails])
    @user = User.find(params[:user_id])
    respond_to do |format|
      if @userdetails.save
        flash[:notice] = 'Userdetails was successfully created.'
        format.html { redirect_to(@user) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /userdetails/1
  # PUT /userdetails/1.xml
  def update
    @userdetails = Userdetails.find(params[:id])
    
    # @user = User.find(@userdetails.user_id) || current_user
    @user = current_user
    
    respond_to do |format|
      if @userdetails.update_attributes(params[:userdetails]) and @user.save
        flash[:notice] = t("flash.userdetails.update.notice")
        format.html { redirect_to @user }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /userdetails/1
  # DELETE /userdetails/1.xml
  def destroy
    @userdetails = Userdetails.find(params[:id])
    @userdetails.destroy

  end
  
  protected

  def begin_of_association_chain
    @current_user
  end
  
  private

  def find_imageable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

end
