class Location < ActiveRecord::Base
  attr_accessible :item_id, :country, :city, :address, :zip, :locatable_type, :locatable_id, :user_id, :meetup_id, 
                  :location, :created_at, :updated_at, :lng, :lat, :state
  
  belongs_to :locatable, :polymorphic => true 
  geocoded_by :address
  after_validation :geocode
   
    
  acts_as_taggable_on :tags
    
    
  #validates_presence_of :locatable_id, :locatable_type, :address, :city, :state, :country, :zip, :lat, :lng
  #validates_presence_of :address, :city, :country
  
end
