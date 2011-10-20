# encoding: utf-8
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.



class ApplicationController < ActionController::Base
  helper :all

  protect_from_forgery
     

  before_filter :set_locale, :measures, :itemtypes, :itemstatuses
  
  layout 'application'

  #geocode_ip_address
  
  # GLOBALS
  $search = ''
  $priority_countries = [:DE, :AT, :CH] 

  # Scrub sensitive parameters from your log
  config.filter_parameters :password
  
  # Return true if a parameter corresponding to the given symbol was posted.
  def param_posted?(sym)
    request.post? and params[sym]
  end
  
  # Auto-geocode the user's ip address and store in the session.
  def geokit
    @geolocation = session[:geo_location]  # @location is a GeoLoc instance.
  end
    
  def geocode
      ip
  end
  
  
  def getNeedsAndOffers(scope, itemTypes)
    @resources_needed = Hash.new
    @resources_offered = Hash.new
    for itemType in itemTypes do 
      it = itemType.title.downcase
      it_sym = "#{it}".to_sym
      items = eval(scope + ".#{it}")
      @resources_needed[it_sym] = { "needed".to_sym => items.need }
      @resources_offered[it_sym] = { "offered".to_sym => items.offer }
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
  
  private
  
  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  
  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = params[:locale]  || 'de'
  end 
  
  def set_user_language
    I18n.locale = (current_user.userdetails.language if logged_in?) || set_locale
  end

  def getLocationOnMap(location, title, imagepath)
  
    if !location.lat and !location.lng
       #geocode
       #location.lat = @user_location.lat
       #location.lng = @user_location.lng
    end
  
    if location.lat and location.lng
      @map = GMap.new("map")
      @map.control_init(:large_map => true,:map_type => true)
      @map.icon_global_init(
        GIcon.new(
          :image => imagepath,
          :info_window_anchor => GPoint.new(9,2),
          :icon_anchor => GPoint.new(7,7)
        ),
        "icon"
      )
      icon = Variable.new("icon")
      @entitylocation = GMarker.new([location.lat,location.lng], 
        :icon => icon,
        :title => "#{title}", 
        :info_window => "<h2>#{title}</h2>#{location.city}"
      )
      @map.overlay_init(@entitylocation)
      @map.center_zoom_init([location.lat,location.lng], 14)
    end
  end 
  
  def getLocationsOnMap(locations, title, imagepath)
    if locations.kind_of?(Array)  
      locations.each do |location|
        getLocationOnMap(location, title, imagepath)
      end 
    else 
      getLocationOnMap(locations, title, imagepath)
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
  
  protected
  
  def measures
    @measures ||= Measure.all
  end 
  
  def itemtypes
    @itemtypes ||= ItemType.find(:all)
  end 
  
  def itemstatuses
    @itemstatuses ||= ItemStatus.find(:all)
  end
  
  def ip
  #  @user_location ||= GeoKit::Geocoders::MultiGeocoder.geocode(request.remote_ip)
  end
  
  #def current_user
  #  @current_user ||= User.find(session[:user_id])
  #end
    
end
