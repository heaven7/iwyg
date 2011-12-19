class Location < ActiveRecord::Base
  attr_accessible :item_id, :country, :city, :address, :zip, :locatable_type, :locatable_id, :user_id, :meetup_id, 
                  :location, :created_at, :updated_at, :lng, :lat, :state
  
  belongs_to :locatable, :polymorphic => true 
  geocoded_by :address, :latitude  => :lng, :longitude => :lat, :units => :km
  after_validation :geocode, :if => :address_changed?
   
  acts_as_gmappable :lat => "lat", :lng => "lng", :validation => true
  acts_as_taggable_on :tags
    
    
  #validates_presence_of :locatable_id, :locatable_type, :address, :city, :state, :country, :zip, :lat, :lng
  #validates_presence_of :address, :city, :country
  
  #def self.address
  #  [address, city, zip, country].compact.join(', ')
  #end
  
  def gmaps4rails_address
    "#{self.address}, #{self.city}, #{self.state}, #{self.zip}"
  end
  
  #def gmaps4rails_infowindow
  #   "<h4>#{city}</h4>" << "<h4>#{address}</h4>"
  #end
  
end
