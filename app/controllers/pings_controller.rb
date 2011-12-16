class PingsController < InheritedResources::Base
  
  layout :conditional_layout
  respond_to :html #, :xml, :json
  helper :items, :users
  belongs_to :pingable, :polymorphic => true
  before_filter :login_required, :only => [:new, :edit]
  
  has_scope :open
  has_scope :non_open
  has_scope :accepted
  has_scope :declined
  has_scope :closed

  def index
    @pingable = find_pingable
    if @pingable.class.to_s == "User"
      @user = User.find(params[:user_id])
      @pings = @user.pings
      @active_menuitem_l1 = I18n.t "menu.user.pings" 
      @active_menuitem_l1_link = user_pings_path  
      @inverse_pings = Array.new
      @user.items.each do |i|
        @inverse_pings << i.pings
      end 
      
      @pings_all = @pings
      @pings_all << @inverse_pings
      @pings_all = @pings_all.paginate(
        :page => params[:page],
        :per_page => PINGS_PER_PAGE,
        :order => "created_at DESC"
      )  
      
    elsif @pingable.class.to_s == "Item"
      @user = current_user
      @item = Item.find(params[:item_id])
      @pings = @item.pings
      @pings.paginate(
         :page => params[:page],
        :per_page => PINGS_PER_PAGE,
        :order => "created_at DESC"
      )    
    else
      @pings = Ping.find(:all, :order => "pings.created_at DESC" )
      @pings.paginate(
         :page => params[:page],
        :per_page => PINGS_PER_PAGE,
        :order => "created_at DESC"
      )   
    end
  end
  
  
  def new
    @pingable = find_pingable
    @ping = Ping.new
  end
  
  
  def edit
    @pingable = find_pingable
    if @pingable
      @ping = @pingable.pings.find(params[:id])
    else
      @ping = Ping.find(params[:id])
    end
  end
  
  
  def show
    @pingable = find_pingable
    if @pingable
      @ping = @pingable.pings.find(params[:id])
    else
      @ping = Ping.find(params[:id])
    end
    
    @comments = @ping.comments.find(:all, :order => "created_at DESC")
    @user = User.find(@ping.user_id)
  end
  
  def create
    @params = params[:ping]
    @params[:status] = 1
    @pingable = find_pingable
    @ping = @pingable.pings.build(@params)
    @resourceType = @pingable.class.to_s
    @resource = @pingable.class.find(@ping.pingable_id)
    
    if @resourceType == "User"
      @owner = @resource
    else
      @owner = User.find(@resource.user_id)
    end
    
    if @owner == current_user
      if @resourceType == "User"
        flash[:error] = t("flash.pings.create.error.pingself") 
      else
        flash[:error] = t("flash.pings.create.error.pingown", :resourceType => @resourceType) 
      end
      redirect_to(@resource)    
    elsif @resourceType == "Transfer"
      @ping.save
      flash[:notice] = t("flash.pings.create.notice")
      redirect_to [@resource]
    elsif @ping.exists? and not @resource.multiple
      flash[:error] = t("flash.pings.create.error.pingedAlready", :type => @resource.localized_itemtype)
      redirect_to(@resource)    
    elsif @ping.save
      flash[:notice] = t("flash.pings.create.notice")
      redirect_to [@resource]
    else
      render :action => 'new'
    end
  end
  
  def update
    @pingable = find_pingable
    #@ping = Ping.find(params[:id])
    @ping = @pingable.pings.find(params[:id])
    if @ping.update_attributes(params[:ping])
      flash[:notice] = t("flash.pings.update.notice")
      redirect_to @parent_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @pingable = find_pingable
    @ping = Ping.find(params[:id])
    @ping.destroy
    flash[:notice] = t("flash.pings.destroy.notice")
    redirect_to @pingable
  end
  
  def accept
    @ping = Ping.find(params[:id])
    @pingable = @ping.pingable_type
    @resource = @pingable.classify.constantize.find(@ping.pingable_id)
    @user = User.find(@ping.user_id)
    @holder = User.find(@resource.user_id)
    
    if current_user.id == @resource.user_id
      if @ping.status.to_i == 2 and  @resource.multiple == false
        flash[:error] = t("flash.pings.accept.error.alreadyAccepted") 
      else
        # set ping to status accepted and close other pings of item
        # the resource itself will have status: requested or offered
        if @ping.update_attributes('status' => 2, 'accepted_at' => Time.now)
          if @pingable == "Item" and @resource.need? 
            @resource.update_attributes('status' => 3)
          else
            @resource.update_attributes('status' => 2)
          end 
          if @resource.multiple == false
            # close other pings on that resource
            @resource.pings.each do |ping|
              if (ping.status.to_i == 1 and @pingable == "Item" ) 
                ping.update_attributes('status' => 4)
              end
            end
          end
          flash[:notice] = t("flash.pings.accept.notice")
        end
      end
    else
      flash[:error] = t("flash.pings.accept.error.notAllowed")
    end
    redirect_to(@resource)
  end
  
  def decline
    @ping = Ping.find(params[:id])
    @pingable = @ping.pingable_type
    @resource = @pingable.classify.constantize.find(@ping.pingable_id)
    @user = User.find(@ping.user_id)
    @holder = User.find(@resource.user_id)
    
    if current_user.id == @resource.user_id
      if @ping.status.to_i == 2
        flash[:error] = t("flash.pings.decline.error.alreadyAccepted")
      elsif @ping.status.to_i == 3
        flash[:error] = t("flash.pings.decline.error.alreadyDeclined")
      else 
        if @ping.update_attributes('status' => 3)
          flash[:notice] = t("flash.pings.decline.notice")
        end
      end
    else
      flash[:error] = t("flash.pings.decline.error.notAllowed")
    end
    redirect_to(@resource)
  end
 
  private

  def find_pingable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
  
  protected
    
  def conditional_layout
    case action_name
      when "new", "create" then "application"
      else "userarea"
    end
  end
  
end
