
class Location < ActiveRecord::Base

  	include RailsSettings::Extend

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
		[address, city, zip, country].compact.join(', ') # if not address.nil? and not city.nil? and not zip.nil? and not country.nil?
	end

	def gmaps4rails_infowindow
		resource = self.locatable
		case resource.class.name.to_s
	 	when "User"
	 		path = "/users/#{resource.id}"
	 		header = "this is a user"
	 	when "Item"
	 		item = resource
	 		path = "/items/#{item.slug || item.id}"
	 		itemtype = item.localized_itemtype
	 		icon = item.icon
	 		status = I18n.t("resources.#{item.needed?}").html_safe

	 		header = "#{icon} #{itemtype} #{status}"
	 	when "Group"
	 		path = "/groups/#{resource.id}"
	 		header = "this is a group"
	 	end 

		
		if Thread.current[:current_user]
			infoaddress = "#{address}<br />#{city}"
		else
			infoaddress = "#{city}"
		end

		"
		<p class=\"font-smaller left\">
			#{header}
		</p>
		<b><a href=\"#{path}\" title=\"#{getTitleForWindow}\">#{getTitleForWindow}</a></b>
		<hr />
		<p class=\"font-smaller left\">
		 #{infoaddress} #{country}
		</p>"
		
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
