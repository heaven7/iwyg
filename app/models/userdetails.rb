class Userdetails < ActiveRecord::Base  
  attr_accessible  :skills, :aims, :interests, :wishes, :images_attributes, :location, :location_attributes,
                   :occupation, :company, :birthdate, :lastname, :firstname, :user_id
  belongs_to :user
  has_associated_audits
  acts_as_audited

end
