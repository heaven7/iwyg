# encoding: utf-8
class ApplicationController < ActionController::Base

  #rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  #rescue_from ActiveRecord::StatementInvalid, :with => :not_found

  helper :all

  protect_from_forgery
  protect_from_forgery :secret => "123456789012345678901234567890iwyg0815"   

  before_filter :set_locale, :measures, :itemtypes, :itemstatuses, :set_current_user

  layout 'application'

  #geocode
  
  # GLOBALS
  $search = Item.search()
  $priority_countries = [:DE, :AT, :CH] 

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
  
  def flash_redirect(msg, *params)
    flash[:notice] = msg
    redirect_to(*params)
  end


  # replacement for the former restful_authentication plugin
  def logged_in?
    user_signed_in?
  end
  
  def login_required
     authenticate_user!
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
    return model.classify.constantize.tagged_with(@tag) if @tag
	end

	def searchByRangeIn(model)
		if params[:within].present? && (params[:within].to_i > 0)
			@location_city = (request.location.city.blank?) ? "Bad Saulgau": request.location.city  
			@locations = Location.where(locatable_type: model).near(@location_city,params[:within])
			@ids = []			
			@locations.each do |l|
				@ids << l.locatable_id.to_i			
			end			
			return model.classify.constantize.where(:id => @ids).search(params[:q])
    end
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
  
  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  
  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    # I18n.locale = params[:locale]  || 'de'

    # get the language set in the browser
    I18n.locale = params[:locale] || ((lang = request.env['HTTP_ACCEPT_LANGUAGE']) && lang[/^[a-z]{2}/])
  end 
  
  def set_user_language
    I18n.locale = (current_user.userdetails.language if logged_in?) || set_locale
  end


 	def getLocationsOnMap(object)
    @locations_json = object.locations.to_gmaps4rails
  end
  


	def set_current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  protected

  
  def measures
    @measures ||= Measure.find(:all)
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
