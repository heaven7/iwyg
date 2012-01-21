class Meetup < ActiveRecord::Base
  attr_accessible :title, :description,
                  :events, :events_attributes, :eventable_id, :eventable_type,
                  :locations, :locations_attributes,
                  :owner_id, :ownertype,
                  :user_ids, :item_attachments, :item_attachments_attributes

     
  belongs_to :owner, :class_name => 'User', :foreign_key => "owner_id"
  has_many :locations, :as => :locatable, :dependent => :destroy
  accepts_nested_attributes_for :locations, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }  
  has_many :events, :as => :eventable, :dependent => :destroy
  accepts_nested_attributes_for :events, :allow_destroy => true  
  has_many :meetings
  has_many :users, :through => :meetings
  has_many :item_attachments, :foreign_key => "meetup_id", :dependent => :destroy
  accepts_nested_attributes_for :item_attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } } 

    
  # validates_numericality_of :participant_ids
  # validates_inclusion_of :user_ids, :in => %w( current_user.id ), :message => "Add yourself to Memberslist"
  validates :title, :presence => true
  #validates :participant_ids, :numericality => true

  def self.exists?(owner_id, ownertype)
    not find_by_owner_id_and_ownertype(owner_id, ownertype).nil?
  end
  
  def owner
    User.find(self.owner_id)
  end
  
  def reject_events(attributed)
    attributes['from'].blank?
  end
  
end
