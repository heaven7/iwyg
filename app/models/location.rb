class Location < ActiveRecord::Base
  attr_accessible :item_id, :country, :city, :address, :zip, :locatable_type, :locatable_id, :user_id, :meetup_id, 
                  :location, :created_at, :updated_at, :lng, :lat, :state
  
  belongs_to :locatable, :polymorphic => true 
  geocoded_by :address, :latitude  => :lat, :longitude => :lng, :units => :km
  after_validation :geocode, :if => :address_changed?
   
  acts_as_gmappable :lat => "lat", :lng => "lng", :validation => false, :process_geocoding => false
  acts_as_taggable_on :tags
  
  def gmaps4rails_address
    # [address, city, zip, country].compact.join(', ') if not address.nil? or not city.nil? or not zip.nil? or not country.nil?
    self.address
  end
  
  def gmaps4rails_infowindow
     "<h2>#{city}</h2>" << "<h4>#{country}</h4>"
  end
  
end
