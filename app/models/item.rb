class Item < ActiveRecord::Base

  
  attr_accessible :locatable_type, :locatable_id, :title, :amount, :measure_id, :measure,
    :description, :item_type_id, :need, :from, :till, :user_id,
    :locations_attributes, :images_attributes, :events_attributes,
    :item_attachments_attributes, :tag_list, :_delete, :status, :multiple
  
  # ajaxful_rateable :stars => 5, :dimensions => [:quality, :delivery]
  
  belongs_to :user
  acts_as_taggable_on :tags
  
  # scopes
  scope :on_hold, :conditions => {:status => 1} 
  scope :offered, :conditions => {:status => 2} 
  scope :requested, :conditions => {:status => 3} 
  scope :on_transfer, :conditions => {:status => 4}
  
  scope :multiple, :conditions => {:multiple => 1}
  scope :need, :conditions => {:need => 1}
  scope :offer, :conditions => {:need => 0}  
  
  scope :good, :conditions => {:item_type_id => 1}       
  scope :transport, :conditions => {:item_type_id => 2}
  scope :service, :conditions => {:item_type_id => 3}    
  scope :sharingpoint, :conditions => {:item_type_id => 4}
  scope :idea, :conditions => {:item_type_id => 5}
  scope :knowledge, :conditions => {:item_type_id => 5}
  scope :skill, :conditions => {:item_type_id => 6}
  
  
  # has_many
  has_many :events, :as => :eventable
  accepts_nested_attributes_for :events, :allow_destroy => true , :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } } 
  has_many :locations, :as => :locatable
  accepts_nested_attributes_for :locations, :reject_if => lambda { |attrs| attrs[:address].blank? }, :allow_destroy => true
  has_many :accounts
  has_many :comments, :as => :commentable
  has_many :transfers, :as => :transferable
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
  
  # delegations
  delegate :city, :lat, :lng, :to => :locations
  delegate :taken, :given, :to => :accounts
  # delegate :from, :till, :to => :events
  
  # validation
  validates_associated :images, :item_attachments  
  validates_presence_of :title, :item_type_id
  #validates_presence_of :need, :null => true
  

 
  
  # search
  def self.prepare_search_scopes(params = {})
    
    if params[:user_id]
      @user = User.find(params[:user_id])
      scope = @user.items.search
    else
      scope = self.search
    end 
     
    scope.measure_id_equals(params[:search][:measure_id_equals])  if not params[:search][:measure_id_equals].blank?
    scope.amount_equals(params[:search][:amount_equals]) if not params[:search][:amount_equals].blank?
    scope.need_equals(params[:search][:need_equals]) if not params[:search][:need_equals].blank?
    scope.from_gte(params[:search][:from_gte].to_date) if not params[:search][:from_gte].blank?
    scope.till_lte(params[:search][:till_lte].to_date) if not params[:search][:till_lte].blank?
    scope.item_type_id_equals(params[:search][:item_type_id_equals].to_i) if not params[:search][:item_type_id_equals].blank?
    scope.title_like_any(params[:search][:title_like_any]) if not params[:search][:title_like_any].blank?
    scope.user_id_equals(params[:search][:user_id]) if not params[:search][:user_id].blank?
    # if params[:search][:order]
    #    order = params[:search][:order]
    #    parts = order.split("_")
    #    direction = parts[0] == "ascend" ? "ASC" : "DESC"
    #    if parts[3]
    #      scope.order = "#{parts[2]}_#{parts[3]} #{direction}"
    #    elsif parts[2]
    #     scope.order = "#{parts[2]} #{direction}"
    #    end
    # end
    return scope
  end
  
  def tag_list_name
    self.tag_list if tag_list
  end
  
  def tag_list_name=(name)
    self.tag_list = Tag.find_or_create_by_name(name) unless name.blank?
  end
  
  def owner
    User.find(self.user_id)
  end
  
  def owner?
    self.owner == @current_user
  end
  
  def multiple?
    self.multiple
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
    ItemType.find(self.item_type_id).title.to_s
  end
  
  def localized_itemtype
    I18n.translate(itemtype.downcase, :count => 1).gsub("1 ", "")
  end
  
  def itemstatus
    ItemStatus.find(self.status).title.to_s
  end
  
  def icon
    it = self.itemtype.downcase
    lit = self.localized_itemtype
    "<img src=\"/images/icons/icon_#{it}.png\" title =\"#{lit}\" alt =\"#{lit}\" />"
  end
    
end
