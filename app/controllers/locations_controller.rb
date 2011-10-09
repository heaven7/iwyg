class LocationsController < InheritedResources::Base
  layout 'userarea'
  respond_to :html #, :xml, :json
  belongs_to :locatable, :polymorphic => true
  
  
  before_filter :login_required, :exept => [:index, :show]
  
  def index
    @locatable = find_locatable
    if @locatable
      @locations = @locatable.locations
    else
      @locations = Location.all
    end
  end
  
  def new
    @locatable = find_locatable
  end
  
  def edit
    @user = User.find(params[:user_id])
    @locatable = find_locatable
    @location = @locatable.location
  end
  
  
  def show
    @locatable = find_locatable
    @location = @locatable.location
  end
  
  def create
    @locatable = find_locatable
    @location = @locatable.locations.build(params[:location])
  
    if @location.save
      flash[:notice] = t("flash.locations.create.notice")
      redirect_to [@locatable, @locations]
    else
      render :action => 'new'
    end
  end
  
  def update
    @user = User.find(params[:user_id])
    @locatable = find_locatable
    @location = @locatable.location
    @location.address = params[:location][:address]
    @location.country = params[:location][:country]
    @location.city = params[:location][:city]
    @location.zip = params[:location][:zip]
    @location.state = params[:location][:state]
    @location.user_id = params[:location][:user_id]
    @location.locatable_id = params[:location][:locatable_id]
    @location.locatable_type = params[:location][:locatable_type]
    
    if @location.update_attributes(params[:location])
      flash[:notice] = t("flash.locations.update.notice") 
      redirect_to @locatable
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    flash[:notice] = t("flash.locations.destroy.notice")
    redirect_to collection_url
  end
 
  
  private

  def find_locatable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
