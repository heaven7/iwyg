class ItemsController < InheritedResources::Base
  protect_from_forgery :except => [:tag_suggestions]

  
  layout :conditional_layout
  respond_to :html, :xml, :js, :json
  before_filter :authenticate_user!, :only => [:new, :edit, :create]
  helper :users, :transfers
  
  has_scope :on_hold
  has_scope :accepted 
  has_scope :requested
  has_scope :on_transfer
  has_scope :multiple
  has_scope :need
  has_scope :offer
  has_scope :good
  has_scope :service
  has_scope :transport
  has_scope :idea
  has_scope :sharingpoint

  def index
    params[:search] = params[:q] if params[:q]
    @geolocation = session[:geo_location] 
    @finder = find_something
    if params[:user_id] && current_user && params[:user_id].to_i == current_user.id.to_i
      @userSubtitle = "i"
    else
      @userSubtitle = "user"
    end
    @itemTypes = ItemType.all
    
    # search by itemType
    if params[:search] and !params[:tag]   
      if not params[:search][:item_type_id_eq].blank?
        @searchItemType = ItemType.find(params[:search][:item_type_id_eq]).title.to_s
      else
        @searchItemType = "Resource"
      end
      
      if not params[:search][:title_cont].blank?     
        @keywords = params[:search][:title_cont].to_s.split
        @keyword_items = ""
        @keywords.each do |keyword|
          if @keywords.last == keyword then
            @keyword_items += "(:title =~ '%#{keyword}%' )"  
          else
            @keyword_items += "(:title =~ '%#{keyword}%' ) | "  
          end
        end
        params[:search][:title_contains] = eval(@keyword_items)
        
        
        @searcher ||= current_user.id if current_user
        # save search      
        for keyword in @keywords
         Search.create(:keyword => keyword, :user_id => @searcher, :ip => request.env['REMOTE_ADDR'])
        end 
      end
      
      $search = Item.search(params[:search])
      $search.sorts ||= :ascend_by_created_at
      @items = $search.result(:distinct => true).paginate( 
        :page => params[:page],
        :order => "created_at DESC", 
        :per_page => ITEMS_PER_PAGE 
      )
      @items_count = @items.count
      
      if params[:user_id] || params[:search][:user_id_eq]
        @user = User.find(params[:user_id] || params[:search][:user_id_eq])       
        $search = @user.items.search(params[:search]) 
        @active_menuitem_l1 = I18n.t "menu.main.resources"
        @active_menuitem_l1_link = user_items_path         
        @active_menuitem_l2 = @searchItemType.downcase          
        render :layout => 'userarea'
      else
        $search = Item.search(params[:search])
      #  index!
      end
    elsif params[:tag] && params[:search]       
      # search by tag and search params
      @tag = params[:tag]
      @tagtype = "tag"
      @searchItemType = "Resource"
      @items = Item.tagged_with(@tag).search(params[:search]).result.paginate(
        :page => params[:page],
        :order => "created_at DESC",
        :per_page => ITEMS_PER_PAGE
      )
      @items_count = @items.size  
    
    elsif params[:tag]
      # search by tag
      @tag = params[:tag]
      @tagtype = "tag"
      @searchItemType = "Resource"
      @items = Item.tagged_with(@tag).search(params[:search]).result.paginate(
        :page => params[:page],
        :per_page => ITEMS_PER_PAGE,
        :order => "created_at DESC"
      )
      @items_count = @items.size      
    else
      # normal listing
      @searchItemType = "Resource"
      #$search = Item.scoped(:order => "created_at DESC", :include => [:images] ).search(params[:search])
      $search = Item.search(params[:search], :indlude => [:comments, :images, :pings])
      @items = $search.result.paginate(
        :page => params[:page],
        :per_page => ITEMS_PER_PAGE,
        :order => "created_at DESC",
        :include => :pings
      )
      if @finder
        @user = User.find(params[:user_id])
        @active_menuitem_l1 = I18n.t "menu.main.resources"   
        @active_menuitem_l1_link = user_items_path
        
        @items_offered = @user.items.offer
        @items_needed = @user.items.need
        @items_taken =  @user.items_taken
        @items_given = @user.items_given
        
        getUsersGivenAndTaken(@user, @itemTypes)
        getNeedsAndOffers("@user.items", @itemTypes)
    
        render :layout => 'userarea'
      end
      @items_count = $search.result.count

    end
    
  end
  
  def search
    index
    render :index
  end
  
  def show
    #@item = Item.find(params[:id], :include => [:images, :pings, :comments, :locations, :events, :tags, :item_attachments])
    @item = Item.where( :id => params[:id]).includes([:images, :pings, :comments, :locations, :events, :tags, :item_attachments])
    @item = @item.first
    @user = current_user

    # related resources
    @titleParts = @item.title.split(" ")

    if @item.need == true
      @items_related_tagged_same = Item.offer.tagged_with(@item.tags.join(', ')).where(:item_type_id => @item.item_type_id)
      @titleParts.each do |part|
          @items_related_titled_same = Item.offer.where(:title.matches => "%#{part}%") if part.length.to_i >= 5
      end
      @items_related_title = I18n.t("item.related.offer").html_safe
    else
      @items_related_tagged_same = Item.need.tagged_with(@item.tags.join(', ')).where(:item_type_id => @item.item_type_id)
      @titleParts.each do |part|
        @items_related_titled_same = Item.need.where(:title.matches => "%#{part}%") if part.length.to_i >= 5
      end
      @items_related_title = I18n.t("item.related.need").html_safe
    end
    if not @items_related_titled_same.nil?
      @items_related = @items_related_tagged_same + @items_related_titled_same
    else
      @items_related = @items_related_tagged_same
    end
    
    @pings = @item.pings
    @comments = @item.comments.find(:all, :order => "created_at DESC")
    @user = User.find(@item.user_id)
    @events = @item.events
    @location = @item.locations.first || @item.owner.location
    getLocation(@item) if @location.lat and @location.lng
    @resource = @item
    getItemTypes
  end
  
  def new
    
    @item = Item.new
    @user = current_user
    
    @active_menuitem_l1 = I18n.t "menu.main.resources"   
    @active_menuitem_l1_link = user_items_path
    @item.locations.build
    @item.events.build
    # @item.images.build
    # @item.item_attachments.build
    
    getItemTypes
  end
  
  def edit
    @item = current_user.items.find(params[:id], :include => [:locations, :events])    
    @location = @item.locations.first || @item.locations.build
    @event = @item.events.first || @item.events.build
    getLocation(@item) if @location.lat and @location.lng
    @user = User.find(@item.user_id)
    getItemTypes
  end
  
  def update
    @item = current_user.items.find(params[:id])
   # @item.images = Image.new(params[:item][:images_attributes])
    getItemTypes
  
    if @item.update_attributes(params[:item])
      flash[:notice] = t("flash.items.update.notice")
      redirect_to @item
    else
      render :action => 'edit'
    end
  end
  
  def create
    @item = Item.new(params[:item])
    @user = current_user
    getItemTypes
    #@item.location = Location.new(params[:item][:location_attributes])
    create!
  end
  
  def destroy
    @user = current_user
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to @user
  end

  def follow
    @item = Item.find(params[:id])
    if current_user.following?(@item)
      flash[:notice] = t("flash.items.follow.error.alreadyFollowing")
    else
      current_user.follow(@item)
      flash[:notice] = t("flash.items.follow.notice", :title => @item.title)
    end
    
    redirect_to(@item)
  end
  
  def rate
    @item = Item.find(params[:id])
    @item.rate(params[:stars], current_user, params[:dimension])
    id = "ajaxful-rating-#{!params[:dimension].blank? ? "#{params[:dimension]}-" : ''}item-#{@item.id}"
    render :update do |page|
      page.replace_html id, ratings_for(@item, :wrap => false, :dimension => params[:dimension])
      page.visual_effect :highlight, id
    end
  end
  
  def tag_suggestions
    @context = params[:c]
    if @context 
       @tags = User.tag_counts_on(@context).find(:all, :conditions => ["name LIKE ?", "%#{params[:term]}%"], :limit=> params[:limit] || 5)
    else
       @tags = Item.tag_counts_on("tags").find(:all, :conditions => ["name LIKE ?", "%#{params[:term]}%"], :limit=> params[:limit] || 5)
    end
    
    #@tags.join(',').split(',')
    render  :json => @tags.join(',').split(',')
  end

  private

  def prepare_search
    #searchlogic scopes
    $scope = Item.prepare_search_scopes(params)
  end
  
  def find_something
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
  
  def getUsersGivenAndTaken(user, itemTypes)
    @resources_given = Hash.new
    @resources_taken = Hash.new
    for itemType in itemTypes do 
      it = itemType.title.downcase
      it_sym = "#{it}".to_sym
      @resources_given[it_sym] = { "given".to_sym => eval("user.items_given" + ".#{it}") }
      @resources_taken[it_sym] = { "taken".to_sym => eval("user.items_taken" + ".#{it}") }
    end
  end
  
  def getLocation(item)
    @locations_json = item.locations.to_gmaps4rails
  end
  
  def getItemTypes
    @itemTypes = Hash.new
    ItemType.all.each do |it|
      localized_title = t(it.title.downcase, :count => 1).gsub("1 ", "")
      @itemTypes[localized_title] = it.id 
    end
  end
  
  protected
  
  def collection 
    @items ||= end_of_association_chain.paginate(
      :page => params[:page],
      :per_page => 24,
      :include => :pings, 
      :order => "#{@sort_by} #{@direction}"
    )
  end
  
  def conditional_layout
    case action_name
      when "new", "edit" then "userarea"
      else "application"
    end
  end
  
end
