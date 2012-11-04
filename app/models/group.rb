class Group < ActiveRecord::Base

  extend FriendlyId
  friendly_id :title, :use => [:slugged, :history]

  attr_accessible :user_id, :user_ids, :title, :description, :tag_list, :tag_tokens, :locations, :users,
    :images_attributes, :locations_attributes, :image_file_name, :image_content_type, :image_file_size

  attr_reader :tag_tokens

  acts_as_followable
  acts_as_paranoid
  acts_as_taggable_on :tags
  acts_as_audited

  belongs_to :user
  has_many :groupings
  has_many :users, :through => :groupings, :conditions => "accepted_at is NOT NULL"
  has_many :inverse_groupings, :class_name => "Grouping", :foreign_key => "group_id"
  has_many :users_invited, :through => :inverse_groupings, :source => :user, :conditions => "accepted_at is NULL"
  
	has_many :locations, :as => :locatable, :dependent => :destroy
  accepts_nested_attributes_for :locations, :allow_destroy => true, :reject_if => proc { |attrs| attrs.blank? }
  has_many :images, :as => :imageable, :dependent => :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true#, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
  has_many :item_attachments, :dependent => :destroy
  accepts_nested_attributes_for :item_attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:attachment_id].blank? }
  has_many :pings, :as => :pingable, :dependent => :destroy
  has_many :inverse_pings, :source => "Ping", :foreign_key => :pingable_id, :conditions => 'pingable_type = Group'

  has_one :custom, :as => :customable

  validates :title, :presence => true

  def owner
    User.find(self.user_id) if self.user_id
  end

  def owner?
    if self.user_id
      true
    else
      false
    end
  end

  def member?(user)
    self.users.include?(user)
  end

  def self.title
    self.title.html_safe if self.title
  end

  def tag_list_name
    self.tag_list if tag_list
  end

  def tag_list_name=(name)
    self.tag_list = Tag.find_or_create_by_name(name) unless name.blank?
  end
end
