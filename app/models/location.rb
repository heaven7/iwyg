class Location < ActiveRecord::Base
  attr_accessible :item_id, :country, :city, :address, :zip, :locatable_type, :locatable_id, :user_id, :meetup_id, 
                  :location, :created_at, :updated_at, :lng, :lat, :state
  
  belongs_to :locatable, :polymorphic => true 
  geocoded_by :address, :latitude  => :lat, :longitude => :lng, :units => :km
  after_validation :geocode, :if => :address_changed?
   
  acts_as_gmappable :lat => "lat", :lng => "lng", :validation => false
  acts_as_taggable_on :tags
  # acts_as_audited
  
  #validates_presence_of :locatable_id, :locatable_type, :address, :city, :state, :country, :zip, :lat, :lng
  #validates_presence_of :address, :city, :country
  
  #def self.address
  #  [address, city, zip, country].compact.join(', ')
  #end
  
  def gmaps4rails_address
    [address, city, zip, country].compact.join(', ') if not address.empty? or not city.empty? or not zip.empty? or not country.empty?
  end
  
  def gmaps4rails_infowindow
     "<h2>#{city}</h2>" << "<h4>#{country}</h4>"
  end
  
end
