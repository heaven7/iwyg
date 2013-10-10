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
    @geolocation = session[:geo_location]
		@itemable = find_model
    @itemTypes = ItemType.all
  	@searchItemType = "Resource"
		@near = params[:near] # || request.location.city 
		@within = params[:within]# || 100
    if params[:user_id] && current_user && params[:user_id].to_i == current_user.id.to_i
      @userSubtitle = "i"
    else
      @userSubtitle = "user"
    end
    
    if params[:q] and !params[:q][:tag] and params[:near].blank?

			# load all items                  	
      listItems(@itemable)
			
			# save search    
			saveSearch(params)

			# search by itemType
		  if not params[:q][:item_type_id_eq].blank?
		    @searchItemType = ItemType.find(params[:q][:item_type_id_eq]).title.to_s
		  end
      
			# search itemable items
			if @itemable
				#$search = @itemable.items.search(params[:q], :indlude => [:comments, :images, :pings])
		    case @itemable.class.to_s
		    when "User"
					@user = @itemable
		      @active_menuitem_l1 = I18n.t "menu.main.resources"
		      @active_menuitem_l1_link = user_items_path         
		      @active_menuitem_l2 = @searchItemType.downcase
		      @active_menuitem_l2_link = user_items_path("q" => params[:q])
		      render :layout => 'userarea'
				when "Group"
		      @group = @itemable       
		      @active_menuitem_l1 = I18n.t "menu.main.resources"
		      @active_menuitem_l1_link = group_items_path         
		      @active_menuitem_l2 = @searchItemType.downcase
		      @active_menuitem_l2_link = group_items_path("q" => params[:q])
		      render :layout => 'groups'
		    end
			end			

    else
			# normal listing of a model's items
      if @itemable
        @active_menuitem_l1 = I18n.t "menu.main.resources"   
        @active_menuitem_l1_link = eval "#{@itemable.class.to_s.downcase}_items_path"
        
        @items_offered = @itemable.items.offered
        @items_needed = @itemable.items.needed
				@used_resources = Item.where('accounts.accountable_id' => @itemable.id, 'accounts.accountable_type' => @itemable.class.to_s)
        @items_taken = @used_resources.taken 
        @items_given = @used_resources.given
        
      
				case @itemable.class.to_s
				when "User"
					@user = @itemable
					@owner = @user.login
	        render :layout => 'userarea'
				when "Group"
					@group = @itemable
					@owner = @group.title
				  render :layout => 'groups'
				end
      end
			# output of normal listing
      listItems(@itemable)
    end

  end
  
  def search
    index
    render :index
  end
  
  def show
		@itemable = find_model
    @item = Item.find(params[:id], :include => [:images, :pings, :comments, :locations, :events, :tags, :item_attachments])
    @user = current_user

    # related resources
    @titleParts = @item.title.split(" ")

    if @item.need == true
      @items_related_tagged_same = Item.offered.tagged_with(@item.tags.join(', ')).where(:item_type_id => @item.item_type_id)
      @titleParts.each do |part|
          @items_related_titled_same = Item.offered.where(:title => "%#{part}%") if part.length.to_i >= 5
      end
      @items_related_title = I18n.t("item.related.offer").html_safe
			@ping_body_msg = I18n.t("ping.pingBodyMessageOnNeed");
			@ping_submit = I18n.t("ping.this.need");
    else
      @items_related_tagged_same = Item.needed.tagged_with(@item.tags.join(', ')).where(:item_type_id => @item.item_type_id)
      @titleParts.each do |part|
        @items_related_titled_same = Item.needed.where(:title => "%#{part}%") if part.length.to_i >= 5
      end
      @items_related_title = I18n.t("item.related.need").html_safe
			@ping_body_msg = I18n.t("ping.pingBodyMessageOnOffer");
			@ping_submit = I18n.t("ping.this.offer");
    end

    if not @items_related_titled_same.nil?
      @items_related = @items_related_tagged_same + @items_related_titled_same
    else
      @items_related = @items_related_tagged_same
    end

    @pings = @item.pings.open_or_accepted
    @comments = @item.comments.find(:all, :order => "created_at DESC")
    @events = @item.events
    @location = @item.locations.first
    getLocation(@item) if @location and @location.lat and @location.lng
    @resource = @item
    getItemTypes
		impressionist(@item)

		@page_title = @item.localized_itemtype + ": " + @item.title unless @item.title.blank? or @item.itemtype.blank?
    @page_description = @item.description unless @item.description.blank?
    @page_keywords = @item.tag_list unless @item.tag_list.count < 1
  end
  
  def new
		@itemable = find_model
    @item = Item.new
    getJSonLocation(@item)
    @user = current_user
    @active_menuitem_l1 = I18n.t "menu.main.resources"   
    @active_menuitem_l1_link = eval "#{@itemable.class.to_s.downcase}_items_path"
    @item.locations.build
    @item.events.build
		case @itemable.class.to_s
		when "User"
			@user = @itemable
      render :layout => 'userarea'
		when "Group"
			@group = @itemable
		  render :layout => 'groups'
		end

		# load default settings into form
    @setting_visible_for = AppSettings.item.visible_for.default
    
    getItemTypes		
  end

	def create 
		@itemable = find_model
		@params = params[:item]
		@item = Item.new(@params) 
		@user = current_user
    getItemTypes
    
		# save settings related to item			
		if @item.save and params[:item][:itemsettings]
			formsettings = params[:item][:itemsettings]
			formsettings.each do |k,v|
				unless v.blank?
					setting = RailsSettings::Settings.new				
					setting.var = k.to_s
					setting.value = v.to_s
					setting.thing_id = @item.id
					setting.thing_type = "Item"				
					setting.save
				end
			end
		end
	  create!
	end

  
  def edit
		@itemable = find_model
    @item = @itemable.items.find(params[:id], :include => [:locations, :events])    
    getJSonLocation(@item)
    @location = @item.locations.first || @item.locations.build
    @event = @item.events.first || @item.events.build
		@event.from = @event.from.to_s(:forms) if @event.from
		@event.till = @event.till.to_s(:forms) if @event.till
    getLocation(@item) if @location.lat and @location.lng
    @user = User.find(@item.user_id)
    getItemTypes

		# find all settings related to this item
		# and assign them
		@settings = RailsSettings::Settings.where(thing_id: @item.id, thing_type: "Item").all
		@setting_visible_for = @settings[0].value.gsub(/[-. ]/, '')
  end
  
  def update
		@itemable = find_model
    @item = current_user.items.find(params[:id])
   # @item.images = Image.new(params[:item][:images_attributes])
    getItemTypes
  
    if @item.update_attributes(params[:item])
			
			# save settings related to item			
			if params[:item][:itemsettings]
				settings = params[:item][:itemsettings]
				settings.each do |k,v|
					@setting = RailsSettings::Settings.where(thing_id: @item.id, thing_type: "Item", var: k).first
					@setting.send("value=",v)
					@setting.save
				end
			end

      flash[:notice] = t("flash.items.update.notice")
      redirect_to @item
    else
      render :action => 'edit'
    end
  end
  
  def destroy
		@itemable = find_model
    @item = Item.find(params[:id])
    @item.destroy
		if @itemable
    	redirect_to @itemable
		else
			redirect_to current_user
		end
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

	def like
    @item = Item.find(params[:id])
		likeOf(current_user, @item)
	end

	def unlike
    @item = Item.find(params[:id])
		unlikeOf(current_user, @item)
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

	# list items depending on if user is logged in or not
	# and on visibility settings of users
	def listItems(itemable)		
		if params[:q] and params[:q][:tag]
			puts "search by tag"
			search = searchByTag(params, "Item").with_settings_for('visible_for').search(params[:q], :include => [:pings]).result(:distinct => true)
		elsif params[:q] and (not params[:within].blank? or not params[:near].blank?)
			puts "location based search"
			search = searchByRangeIn("Item", params).with_settings_for('visible_for').search(params[:q], :include => [:pings]).result(:distinct => true)		
		elsif itemable
			puts "itemable"
			search = itemable.items.with_settings_for('visible_for').search(params[:q], :include => [:pings]).result(:distinct => true)		
		else		
			puts "normal listing"
			search = Item.with_settings_for('visible_for').search(params[:q], :include => [:pings]).result(:distinct => true)
		end
	
		if logged_in?
			items = search.visible_for_members(current_user)
		else
			items = search.visible_for_all
		end

		@items = items.paginate( 
      :page => params[:page],
      :order => "created_at DESC", 
      :per_page => AppSettings.items.per_page 
    )
    @items_count = @items.count
	end

	def saveSearch(params)
	  if params and not params[:q][:title_cont].blank?     
		  @keywords = params[:q][:title_cont].to_s.split
			#puts "SEARCH: " + params[:q][:title_cont]
		  @keyword_items = ""
		  @keywords.each do |keyword|
		    if @keywords.last == keyword then
		      @keyword_items += "(:title =~ '%#{keyword}%' )"  
		    else
		      @keyword_items += "(:title =~ '%#{keyword}%' ) | "  
		    end
		  end
		
		  @searcher ||= current_user.id if current_user  
		  for keyword in @keywords
		   Search.create(:keyword => keyword, :user_id => @searcher, :ip => request.env['REMOTE_ADDR'])
		  end 
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
