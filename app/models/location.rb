class Location < ActiveRecord::Base

	set_rgeo_factory_for_column(:latlon, RGeo::Geographic.spherical_factory(:srid => 4326))
  attr_accessible :item_id, :country, :city, :address, :zip, :locatable_type, :locatable_id, :user_id, :meetup_id, 
                  :location, :created_at, :updated_at, :lng, :lat, :state
  
  belongs_to :locatable, :polymorphic => true 
  geocoded_by :address, :latitude  => :lat, :longitude => :lng, :units => :km
	reverse_geocoded_by :lat, :lng
  after_validation :geocode, :reverse_geocode, :if => :address_changed?
   
  acts_as_gmappable :lat => "lat", :lng => "lng", :validation => false, :process_geocoding => false
  acts_as_taggable_on :tags
  
  def gmaps4rails_address
    [address, city, zip, country].compact.join(', ') # if not address.nil? or not city.nil? or not zip.nil? or not country.nil?
    # address
  end
  
  def gmaps4rails_infowindow
     "<b>#{getTitle}</b><br /><p>#{address}</p>"
  end
  
	def getTitle
		if self.locatable.respond_to?(:title)
			self.locatable.title 
		elsif self.locatable.login
			self.locatable.login 
		end
	end

	reverse_geocoded_by :lat, :lng do |obj,results|
		if geo = results.first
		  obj.city    = geo.city
		  obj.zip = geo.postal_code
		  obj.country = geo.country_code
		end
	end

end
