class Location < ActiveRecord::Base

  	include RailsSettings::Extend 

	set_rgeo_factory_for_column(:latlon, RGeo::Geographic.spherical_factory(:srid => 4326))
  	attr_accessible :item_id, :country, :city, :address, :zip, :locatable_type, :locatable_id, :user_id, :meetup_id, 
                  :location, :created_at, :updated_at, :lng, :lat, :state
  
	belongs_to :locatable, :polymorphic => true 
	geocoded_by :address, :latitude  => :lat, :longitude => :lng, :units => :km
	reverse_geocoded_by :lat, :lng
	after_validation :reverse_geocode #, :if => :address_changed?

	acts_as_gmappable :lat => "lat", :lng => "lng", :validation => false, :process_geocoding => false
	acts_as_taggable_on :tags

	def gmaps4rails_address
		[address, city, zip, country].compact.join(', ') # if not address.nil? and not city.nil? and not zip.nil? and not country.nil?
	end

	def gmaps4rails_infowindow
		if Thread.current[:current_user]
			"<b>#{getTitleForWindow}</b><br /><p class=\"font-smaller\">#{address}<br />#{city} #{I18n.t('country', :scope => "countries" )}</p>"
		else
			"<b>#{getTitleForWindow}</b><br /><p class=\"font-smaller\">#{city} #{I18n.t('country', :scope => "countries" )}</p>"
		end
	end
  
	def getTitleForWindow
		if self.locatable.respond_to?(:title)
			self.locatable.title 
		elsif self.locatable.respond_to?(:login)
			self.locatable.login 
		end
	end

	reverse_geocoded_by :lat, :lng do |obj,results|
		if geo = results.first
			obj.city    	= geo.city
			obj.state   	= geo.state
			obj.zip 		= geo.postal_code
			obj.country 	= geo.country_code
		end
	end

end
