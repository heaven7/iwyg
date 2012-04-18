class ImagesController < InheritedResources::Base

  layout 'userarea'

  respond_to :html#, :xml, :json
  belongs_to :imageable, :polymorphic => true
  
  before_filter :login_required, :exept => [:index, :show]
  
  def index
    @user = current_user
    @imageable = find_imageable
    if @imageable
      @images = @imageable.images
    else
      @images = current_user.images
    end
  end
  
  
  def new
    @user = current_user
    @imageable = find_imageable
    @image = Image.new
  end
  
  
  def edit
    @user = current_user
    @imageable = find_imageable
    @image = @imageable.images.find(params[:id])
  end
  
  
  def show
    @user = current_user
    @image = Image.find(params[:id])
  end
  
  def create
    @imageable = find_imageable
    if @imageable
      @image = @imageable.images.build(params[:image])
    else
      @image = current_user.images.build(params[:image])
    end
    if @image.save
      flash[:notice] =  t("flash.images.create.notice")
      if @imageable
        #redirect_to [@imageable, @images]
        redirect_to :id => nil
      else
        redirect_to [current_user, @images]
      end
    else
      render :action => 'new'
    end
  end
  
  def update
    @user = current_user
    @image = Image.find(params[:id])
    @image.imageable = find_imageable
    if @image.update_attributes(params[:image])
      flash[:notice] = t("flash.images.update.notice")
      redirect_to find_imageable
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    flash[:notice] = t("flash.images.destroy.notice")
    redirect_to collection_url
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
