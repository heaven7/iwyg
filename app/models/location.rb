class Location < ActiveRecord::Base
  attr_accessible :item_id, :country, :city, :address, :zip, :locatable_type, :locatable_id, :user_id, :meetup_id, 
                  :location, :created_at, :updated_at, :lng, :lat, :state
  
  belongs_to :locatable, :polymorphic => true 
  geocoded_by :gmaps4rails_address, :latitude  => :lat, :longitude => :lng, :units => :km
  after_validation :geocode, :if => :address_changed?
   
  acts_as_gmappable :lat => "lat", :lng => "lng"  
  acts_as_taggable_on :tags
    
    
  #validates_presence_of :locatable_id, :locatable_type, :address, :city, :state, :country, :zip, :lat, :lng
  #validates_presence_of :address, :city, :country
  
  def self.address
    [address, city, zip, country].compact.join(', ')
  end
  
  def gmaps4rails_address
  #describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
    "#{self.address}, #{self.city}, #{self.zip}, #{self.country}" 
  end
  
end
