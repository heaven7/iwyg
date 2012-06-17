class Meetup < ActiveRecord::Base
  
  extend FriendlyId
  friendly_id :title

  attr_accessible :title, :description,
    :events, :events_attributes, :eventable_id, :eventable_type,
    :locations, :locations_attributes,
    :owner_id, :ownertype,
    :user_ids, :invited_user_ids, :item_attachments, :item_attachments_attributes
              
 # has_paper_trail
  acts_as_followable
  acts_as_paranoid
  has_associated_audits
  acts_as_audited
  
  belongs_to :owner, :class_name => 'User', :foreign_key => "owner_id"
  has_many :locations, :as => :locatable, :dependent => :destroy
  accepts_nested_attributes_for :locations, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }  
  has_many :events, :as => :eventable, :dependent => :destroy
  accepts_nested_attributes_for :events, :allow_destroy => true  
  has_many :meetings, :dependent => :destroy
  has_many :users, :through => :meetings
  has_many :accepted_users, :through => :meetings, :conditions => "accepted_at > 0", :source => :user
  has_many :item_attachments, :foreign_key => "meetup_id", :dependent => :destroy
  accepts_nested_attributes_for :item_attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } } 

  has_one :custom, :as => :customable

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

  def find_by_meeting_user(user)
    Meeting.joins(:meetup).where(:meetings => {:user_id => user.id}).first
  end
  
end
