class Item < ActiveRecord::Base

  extend FriendlyId
  friendly_id :title, :use => :slugged

  include RailsSettings::Extend 

	attr_accessor :near, :settings  
	attr_accessible :locatable_type, :locatable_id, :title, :amount, :measure_id, :measure,
    :description, :item_type_id, :need, :from, :till, :user_id,
    :locations_attributes, :images_attributes, :events_attributes,
    :item_attachments_attributes, :tag_list, :_delete, :status, :multiple,
		:itemable_id, :itemable_type, :near, :settings
	
  
  # ajaxful_rateable :stars => 5, :dimensions => [:quality, :delivery]
  
  belongs_to :user
	belongs_to :itemable, :polymorphic => true

  acts_as_taggable_on :tags
  acts_as_paranoid
  acts_as_followable
	acts_as_likeable
  acts_as_audited
  has_associated_audits
	is_impressionable
  
  # scopes
	scope :enable, proc { |item| joins(:user, :custom).where('customs.enable' => 1) }
	scope :visible, proc { |item| joins(:user, :custom).where('customs.visible' => 1) }
	scope :on_hold, :conditions => {:status => 1} 
  scope :offered, :conditions => {:status => 2} 
  scope :requested, :conditions => {:status => 3} 
  scope :on_transfer, :conditions => {:status => 4}
  
  scope :multiple, :conditions => {:multiple => true}
  scope :needed, :conditions => {:need => true}
  scope :offered, :conditions => {:need => false}
	scope :taken, proc { |item| joins(:accounts).where('accounts.has_taken' => 1 )}
	scope :given, proc { |item| joins(:accounts).where( 'accounts.has_taken' => 0 ) }
  
  scope :good, :conditions => {:item_type_id => 1}       
  scope :transport, :conditions => {:item_type_id => 2}
  scope :service, :conditions => {:item_type_id => 3}    
  scope :sharingpoint, :conditions => {:item_type_id => 4}
  scope :idea, :conditions => {:item_type_id => 5}
  scope :knowledge, :conditions => {:item_type_id => 5}
  scope :skill, :conditions => {:item_type_id => 6}
  
	## rails_settings_cached
	# be sure to call this scopes like Item.with_settings_for('visible_for').visible_for_all or ...visible_for_members(current_user)
	scope :visible_for_all, -> { where("settings.value LIKE '%all%'") }
	scope :visible_for_members, lambda { |user| where("(settings.value LIKE '%all%' OR settings.value LIKE '%members%') OR (items.user_id = #{user.id} AND settings.value LIKE '%me%') ") }
	scope :visible_for_me, lambda { |user| where(user_id: user.id) }
	
  # has_many
	has_many :accounts, :as => :accountable, :dependent => :destroy     
  has_many :events, :as => :eventable, :dependent => :destroy
  accepts_nested_attributes_for :events, :allow_destroy => true , :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } } 
  has_many :locations, :as => :locatable, :dependent => :destroy
  accepts_nested_attributes_for :locations, :reject_if => lambda { |attrs| attrs[:address].blank? }, :allow_destroy => true
  has_many :accounts
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :transfers, :as => :transferable, :dependent => :destroy
  has_many :images, :as => :imageable, :dependent => :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }  
  has_many :item_attachments, :dependent => :destroy
  accepts_nested_attributes_for :item_attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:attachment_id].blank? } 
  has_many :pings, :as => :pingable, :dependent => :destroy   
  has_many :inverse_pings, :source => "Ping", :foreign_key => :pingable_id, :conditions => 'pingable_type = Item'
  
  # has_one
  has_one :item_type
  has_one :item_status, :as => :status
  has_one :measure
  #has_one :custom, :as => :customable
  
  # delegations
  delegate :city, :lat, :lng, :to => :locations
  delegate :taken, :given, :to => :accounts
	delegate :visible, :enable, :to => :custom
  # delegate :from, :till, :to => :events
  
  # validation
  validates_associated :images, :item_attachments  
  validates_presence_of :title, :item_type_id

	# checks if item is visible for user
  # depending on setting visible_for
	def self.is_visible_for?(user, logged_in)
		setting = self.settings.visible_for || AppSettings.item.visible_for.default
		if logged_in == true
			if user == self.owner # setting == "me"
				return true
			elsif setting	== "members" or setting == "all"
				return true
			elsif setting == "me" and (user == self.owner or user == self.item.owner)
				return true
			end
		elsif setting == "all"
			return true
		end
		false
	end
  
	def can_be_read_by?(user)
		p = self.custom.visible_for
		if p == "all"
	 		return true
		else
			if user
				user = @current_user
				user_ids = p['user_ids']
				group_ids = p['group_ids']

				# is current_user listed in user permissions		
				if user_ids.include?(user)
					return true 
				end

				# is current_user a groupmember of group permissions
				#group_ids.each do |group|
				#	@group = Group.find(group)
				#	if user.is_groupmember?(group)
				# 		return true 
				#	end
				#end		
				#return false
			end
			return true
		end
	end

  def tag_list_name
    self.tag_list if tag_list
  end
  
  def tag_list_name=(name)
    self.tag_list = Tag.find_or_create_by_name(name) unless name.blank?
  end

  def owner
		self.itemable	if self.itemable
	end
  
  def ownerName
		case self.itemable.class.to_s
		when "User"
			title = self.itemable.login
		else
			title = self.itemable.title 
		end	  
	end

	def creator
		User.find(self.user_id) if self.user_id > 0
	end
  
  def multiple?
    self.multiple if self.multiple
  end
  
  def on_transfer?
    @transfer = Transfer.find_by_transferable_id_and_transferable_type(self.id, "Item")
    if self.status.to_i == 4 and @transfer then return true end
    false
  end
  
  def transfer
    @transfer = Transfer.find_by_transferable_id_and_transferable_type(self.id, "Item") if self.on_transfer?
  end
  
  def good?
    self.item_type_id == 1
  end 
  
  def transport?
    self.item_type_id == 2
  end
  
  def service?
    self.item_type_id == 3
  end
  
  def sharingpoint?
    self.item_type_id == 4
  end
  
  def idea?
    self.item_type_id == 5
  end
  
  def knowledge?
    self.item_type_id == 5
  end
    
  def skill?
    self.item_type_id == 6
  end
  
  def itemtype
    ItemType.find(self.item_type_id).title.to_s if self.item_type_id
  end
  
  def localized_itemtype
    I18n.translate(itemtype.downcase, :count => 1).gsub("1 ", "") if itemtype
  end
  
  def itemstatus
    ItemStatus.find(self.status).title.to_s if self.status
  end
  
  def icon
    it = self.itemtype.downcase
    lit = self.localized_itemtype
    "<img src=\"/images/icons/icon_#{it}.png\" title =\"#{lit}\" alt =\"#{lit}\" />"
  end
    
end
