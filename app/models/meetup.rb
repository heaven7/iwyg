class Meetup < ActiveRecord::Base
  attr_accessible :title, :description, :meeting_ids, :user_ids, :events, :events_attributes, :eventable_id, :eventable_type, :locations, :locations_attributes, :owner_id, :ownertype, :user_id  
  
  #validates_numericality_of :user_ids
  # validates_inclusion_of :user_ids, :in => %w( current_user.id ), :message => "Add yourself to Memberslist"
  validates_presence_of :title
     
  belongs_to :owner, :class_name => 'User'
  has_many :locations, :as => :locatable
  accepts_nested_attributes_for :locations, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }  
  has_many :events, :as => :eventable
  accepts_nested_attributes_for :events, :allow_destroy => true  
  has_many :meetings
  has_many :users, :through => :meetings
  #has_many :item_attachments, :dependent => :destroy
  #accepts_nested_attributes_for :item_attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } } 

  
  
  
  def owner
    User.find(self.owner_id)
  end
  
  def reject_events(attributed)
    attributes['from'].blank?
  end
  
end
