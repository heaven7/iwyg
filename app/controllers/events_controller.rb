class EventsController < InheritedResources::Base
  
  layout :conditional_layout
  
  respond_to :html #, :xml, :json
  belongs_to :eventable, :polymorphic => true
  
  before_filter :login_required, :exept => [:index, :show]
  
  has_scope :open
  has_scope :non_open
  has_scope :accepted
  has_scope :declined
  has_scope :closed
  
  def index
    @user = User.find(params[:user_id]) if params[:user_id]
    @eventable = find_eventable
    @reversed_events = Array.new
    if @eventable
      @events = @eventable.events.find(:all, :order => "created_at DESC")
      Event.all.each do |event|  
        @user.pings.each do |ping|
           if event.eventable_id == ping.pingable_id and event.eventable_type == ping.pingable_type
            @reversed_events << event 
           end
        end 
      end
      @events += @reversed_events
 
    else
      @events = Event.all
    end
  end
  
  
  def new
    @user = current_user
    @eventable = find_eventable
    init
    @event = Event.new
  end
  
  
  def edit
    @user = current_user
    @eventable = find_eventable
    @event = @user.events.find(params[:id])
  end
  
  
  def show
    @user = current_user
    @eventable = find_eventable
    @event = Event.find(params[:id])
  end
  
  def create
    @user = current_user
    @eventable = find_eventable
    @event = @eventable.events.build(params[:event])
    init
    if @event.save
      flash[:notice] = t("flash.events.create.notice")
      redirect_to [@event]
    else
      render :action => 'new'
    end
  end
  
  def update
    @user = current_user
    @eventable = find_eventable
    @event = @eventable.events.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:notice] = t("flash.events.update.notice")
      redirect_to [@eventable, @event]
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:notice] = t("flash.events.destroy.notice")
    redirect_to collection_url
  end
 
  
  private

  def find_eventable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
  
  def conditional_layout
    case action_name
      when "new", "edit", "create", "show", "index" then
        if params[:user_id] then "userarea" else "application" end
      else "application"
    end
  end
  
  def init
    if @event || params[:event]
      @eventable_id = params[:event][:eventable_id] || @event.eventable_id 
      @eventable_type = params[:event][:eventable_type] || @event.eventable_type
      @ping = Ping.find(params[:event][:ping] || @event.ping_id) if params[:event][:ping] || @event.ping_id 
      @pinger = User.find(@ping.user_id)  if @ping
      
      if @eventable_type
        case @eventable_type.to_s
        when "Item"
          @item = Item.find(@eventable_id) if @eventable_id
        when "Group"
          @group = Group.find(@eventable_id) if @eventable_id
        end
      end
    end
  end
  
end

