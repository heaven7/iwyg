# encoding: utf-8
class ApplicationController < ActionController::Base

  # GLOBALS
  $search = Item.search()
  $priority_countries = [:DE, :AT, :CH] 

  #rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  #rescue_from ActiveRecord::StatementInvalid, :with => :not_found

  helper :all

  protect_from_forgery
  protect_from_forgery :secret => "123456789012345678901234567890iwyg0815"   

	# filters
  before_filter :set_locale, :measures, :itemtypes, :itemstatuses, :set_current_user
	after_filter :flash_to_headers

	# layout
  layout 'application'

  #geocode
  

  # Scrub sensitive parameters from log
  config.filter_parameters :password
  
  # Return true if a parameter corresponding to the given symbol was posted.
  def param_posted?(sym)
    request.post? and params[sym]
  end
  
  # Auto-geocode the user's ip address and store it in session.
  def geocode
    @geolocation = session[:geo_location] = request.location
  end

  def not_found
   render "public/404.html", status => 404, :layout => false
  end
  
  def getNeedsAndOffers(scope, itemTypes)
    @resources_needed = Hash.new
    @resources_offered = Hash.new
    for itemType in itemTypes do 
      it = itemType.title.downcase
      it_sym = "#{it}".to_sym
      items = eval(scope + ".#{it}")
      @resources_needed[it_sym] = { "needed".to_sym => items.needed }
      @resources_offered[it_sym] = { "offered".to_sym => items.offered }
    end
  end  
  
  # set language
  def default_url_options(options={})  
    #logger.debug "default_url_options is passed options: #{options.inspect}\n" 
    {:locale => I18n.locale }
  end
  
	# redirect of flash
  def flash_redirect(msg, *params)
    flash[:notice] = msg
    redirect_to(*params)
  end

	# flash header of ajax requests
	def flash_to_headers
    return unless request.xhr?
    response.headers['X-Message'] = flash_message
    response.headers["X-Message-Type"] = flash_type.to_s

    flash.discard # don't want the flash to appear when you reload page
  end


  # replacement for the former restful_authentication plugin
  def logged_in?
    user_signed_in?
  end
  
  def login_required
     authenticate_user!
  end
		
	# settings
	def changesetting
		model = params[:model_type].classify.constantize.find(params[:model_id])
		if model.settings.where(:var => params[:setting]).count > 0
			model.settings[params[:setting]] = params[:value]
			@changed = true
		end
	end

  # sozial interactions
  # likes
	def like
		@thing = params[:model_type].classify.constantize.find(params[:model_id])
    @title = getTitle(@thing)
    user = User.find(params[:user])
    user.like!(@thing)
    @likers = getLikers(@thing)
    @likes_count = @likers.size
	end

	def unlike
		@thing = params[:model_type].classify.constantize.find(params[:model_id])
    @title = getTitle(@thing)
    user = User.find(params[:user])
    user.unlike!(@thing)
    @likers = getLikers(@thing)
    @likes_count = @likers.size
	end

  # follows
  def follow
    @thing = params[:model_type].classify.constantize.find(params[:model_id])
    @title = getTitle(@thing)
    user = User.find(params[:user])
    user.follow!(@thing)
    @followers = getFollowers(@thing)
    @followers_count = @followers.size
  end

  def unfollow
    @thing = params[:model_type].classify.constantize.find(params[:model_id])
    @title = getTitle(@thing)
    user = User.find(params[:user])
    user.unfollow!(@thing)
    @followers = getFollowers(@thing)
    @followers_count = @followers.size
  end

  def getLikers(model)
    model.likers(User)
  end

  def getFollowers(model)
    model.followers(User)
  end

  def getTitle(model)
    case model.class.to_s
    when "User"
      @title = @thing.login
    else
      @title = @thing.title
    end
  end

  def find_model
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

	def searchByTag(params, model, tagtype = "tag")
		
    if params[:aim]
      @tag = params[:aim]
      @tagtype = "aim"
    elsif params[:wish]
      @tag = params[:wish]
      @tagtype = "wish"
    elsif params[:interest]
      @tag = params[:interest]
      @tagtype = "interest"
		else
			@tag = params[:q][:tag] if params[:q]
	    @tagtype = tagtype    
		end
    return model.classify.constantize.tagged_with(@tag, :any => true) if @tag
	end

	def searchByRangeIn(model, params=nil)
		if params[:near]
			@location_city = (request.location.city.blank?) ? params[:near] : request.location.city 
			if not params[:within].blank? && params[:within].to_i > 0
				@radius = params[:within]
			else
				@radius = 200
			end			
			@locations = Location.where(locatable_type: model).near(@location_city, @radius, :order => "distance")
	  	if @locations 
				@ids = []			
				@locations.each do |l|
					@ids << l.locatable_id.to_i
				end		
				return model.classify.constantize.where(:id => @ids).order("field(#{model.downcase.pluralize}.id, #{@ids.join(',')})") if @ids.size > 0
				return model.classify.constantize.where(:id => @ids)			
			end
    end
	end

  def getJSonLocation(model)
		klass = model.class.to_s
		case klass
		when "User"
			loc = model.location
		else
			loc = model.locations.first || current_user.location
		end
		@json_location = Hash.new
		@json_location = {'lat' => loc.lat.to_s || request.location.latitude.to_s,
			'lng' => loc.lng.to_s || request.location.longitude.to_s
		}.to_json
  end
	
	def updateNotifications
		if current_user
			action = request[:action]
			user = current_user
			id = params[:id]

			if params[:controller].to_s == "sent"
				klass = "Message".classify.constantize
			else
				klass = params[:controller].classify.constantize
			end			
			resource = klass.find(id)

			notifications = Notification.where(
				:receiver_id => user,
				:notifiable_id => id,
				:notifiable_type => klass.to_s		
			)

			# notificatons will be set to read if
			# user will visit page of notifying resource
			if notifications 
				impressions = Impression.where(
					:user_id => user,
					:impressionable_id => id,
					:impressionable_type => klass.to_s 		
				)
				if notifications.size > 1
					impression = impressions.where("created_at > {notifications.first.created_at}")
				else
					impression = impressions.where("created_at > {notifications.created_at}")
				end

	 			if impression
					notifications.each do |n|
						n.update_attributes(:is_read => true)				
					end
				end

			end
		end
	end

  private

	# flash methods
	def flash_message
    [:error, :warning, :notice].each do |type|
        return flash[type] unless flash[type].blank?
    end
  end

  def flash_type
    [:error, :warning, :notice].each do |type|
        return type unless flash[type].blank?
    end
  end
  
  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  
  def set_locale
    # in test-environment en is default
    if Rails.env.test?
      # if params[:locale] is nil then I18n.default_locale will be used
      I18n.locale = params[:locale]  || I18n.default_locale
    else
      # get the language set in the browser
      I18n.locale = params[:locale] || ((lang = request.env['HTTP_ACCEPT_LANGUAGE']) && lang[/^[a-z]{2}/])
    end
  end 
  
  def set_user_language
    I18n.locale = (current_user.userdetails.language if logged_in?) || set_locale
  end


 	def getLocationsOnMap(object)
    @locations_json = object.locations.to_gmaps4rails
  end
  


	def set_current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    Thread.current[:current_user] = @current_user
  end

  protected

  
  def measures
    @measures ||= Measure.all
  end 
  
  def itemtypes
    @itemtypes ||= ItemType.all
  end 
  
  def itemstatuses
    @itemstatuses ||= ItemStatus.all
  end
  
  def ip
  #  @user_location ||= GeoKit::Geocoders::MultiGeocoder.geocode(request.remote_ip)
  end
    
end
