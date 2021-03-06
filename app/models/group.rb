class Group < ActiveRecord::Base

  extend FriendlyId
  friendly_id :title, :use => [:slugged, :history]

  include RailsSettings::Extend 

  attr_accessor :near, :groupsettings  
  attr_accessible :user_id, :member_ids, :members_pending_ids, 
    :title, :description, :tag_list, :tag_tokens, :locations, :users,
    :images_attributes, :locations_attributes, :image_file_name, 
    :image_content_type, :image_file_size, :groupsettings

  attr_reader :tag_tokens

  # callbacks
  after_create :set_defaultsettings

  acts_as_followable
  acts_as_paranoid
  acts_as_taggable_on :tags
  acts_as_audited
	acts_as_likeable
	is_impressionable

  belongs_to :user

  ## rails_settings_cached
  # be sure to call this scopes like Group.with_settings_for('visible_for').visible_for_all or ...visible_for_members(current_user)
  scope :visible_for_all, -> { where("settings.value LIKE '%all%'") }
  scope :visible_for_members, lambda { |user| where("(settings.value LIKE '%all%' OR settings.value LIKE '%members%') OR (groups.user_id = #{user.id} AND settings.value LIKE '%me%') ") }
  scope :visible_for_me, lambda { |user| where(user_id: user.id) }
  

  has_many :items, :as => :itemable, :dependent => :destroy                   
  has_many :groupings, :dependent => :destroy
  has_many :members, :through => :groupings, :source => :user, :conditions => "accepted_at is NOT NULL", :dependent => :destroy
  has_many :inverse_groupings, :class_name => "Grouping", :foreign_key => "group_id", :dependent => :destroy
  has_many :members_pending, :through => :inverse_groupings, :source => :user, :conditions => { "groupings.accepted_at" => nil }, :dependent => :destroy
  #has_many :members_invited, :through => :inverse_groupings, :source => :user, :conditions => { "groupings.accepted_at" => nil }
  
	has_many :locations, :as => :locatable, :dependent => :destroy
  accepts_nested_attributes_for :locations, :allow_destroy => true, :reject_if => proc { |attrs| attrs.blank? }
  has_many :images, :as => :imageable, :dependent => :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true#, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
  has_many :item_attachments, :dependent => :destroy
  accepts_nested_attributes_for :item_attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:attachment_id].blank? }
  #has_many :pings, :as => :pingable, :dependent => :destroy
  #has_many :inverse_pings, :source => "Ping", :foreign_key => :pingable_id, :conditions => 'pingable_type = Group'

  has_one :custom, :as => :customable, :dependent => :destroy

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
    self.members.include?(user)
  end

  def member_pending?(user)
    self.members_pending.include?(user)
  end

  #def title
  #  self.title.html_safe if self.title
  #end

  def tag_list_name
    self.tag_list if tag_list
  end

  def tag_list_name=(name)
    self.tag_list = Tag.find_or_create_by_name(name) unless name.blank?
  end

  # save defaultsettings related to group 
  def set_defaultsettings
    AppSettings.item.to_hash.each do |setting, value|
        s = RailsSettings::Settings.new       
        s.var = setting.to_s
        s.value = value[:default]
        s.thing_id = self.id
        s.thing_type = "Group"       
        s.save
    end
  end
end
