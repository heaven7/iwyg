class Userdetails < ActiveRecord::Base  
  attr_accessible  :skills, :aims, :interests, :wishes, :images_attributes, :location, :location_attributes,
                   :occupation, :company, :birthdate, :lastname, :firstname
  belongs_to :user
end
