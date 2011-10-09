class CustomsController < InheritedResources::Base

  layout 'userarea'

  respond_to :html, :xml, :json
  belongs_to :customable, :polymorphic => true
  
  before_filter :login_required, :exept => [:index, :show]
  
  def index
    @customable = find_customable
    if @customable
      @customs = @customable.customs
    else
      @customs = Custom.all
    end
  end
  
  
  def new
    @customable = find_customable
    @custom = Custom.new
  end
  
  
  def edit
    @customable = find_customable
    @custom = @customable.customs.find(params[:id])
  end
  
  
  def show
    @customable = find_customable
    @custom = @customable.customs.find(params[:id])
  end
  
  def create
    @customable = find_customable
    @custom = @customable.customs.build(params[:custom])
  
    if @custom.save
      flash[:notice] = "Custom saved."
      redirect_to [@customable, @customs]
    else
      render :action => 'new'
    end
  end
  
  def update
    @custom = Custom.find(params[:id])
    @custom.customable = find_customable
    if @custom.update_attributes(params[:custom])
      flash[:notice] = "Successfully updated custom."
      redirect_to find_customable
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @custom = Custom.find(params[:id])
    @custom.destroy
    flash[:notice] = "Successfully destroyed custom."
    redirect_to collection_url
  end
 
  
  private

  def find_customable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
