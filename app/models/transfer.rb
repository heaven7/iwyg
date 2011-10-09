class Transfer < ActiveRecord::Base

  has_many :pings, :as => :pingable
  has_many :comments, :as => :commentable
  has_many :transfer_options
  accepts_nested_attributes_for  :transfer_options, :allow_destroy => false, :reject_if => lambda { |a| a[:transfer].blank? }

  belongs_to :transferable, :polymorphic => true

#  acts_as_taggable_on :tags
  
  attr_accessible :receiver, :transferable_id, :transferable_type
  attr_accessible :pinger, :receiverable_type, :receiverable_id
  attr_accessor :transferoptions, :friends_select, :user_select, :sharingpoint_select
  
 # validates_presence_of :transferoptions, :receiverable_type, :receiverable_id
  
  scope :open, :conditions => { :status => 1 }
  scope :not_closed, :conditions => "status < 4"
  scope :accepted, :conditions => { :status => 2 }
  scope :declined, :conditions => { :status => 3 }
  scope :closed, :conditions => { :status => 4 }


  def self.exists?(transferable_id, transferable_type, user_id)
    not find_by_transferable_id_and_transferable_type_and_user_id(transferable_id, transferable_type, user_id).nil?
  end  
  
  def open?
    self.status == 1
  end
  
  def accepted?
    self.status == 2
  end

  def declined?
    self.status == 3
  end
  
  def closed?
    self.status == 4
  end
  
  def item
    Item.find(self.transferable_id) if self.transferable_type.to_s == "Item"
  end
  
  def itemType
    @item  = self.item
    getItemType(@item)
  end  
  
  def receiver 
    if self.receiverable_id && self.receiverable_type
      case self.receiverable_type.to_s
      when "Item"
        item = Item.find(self.receiverable_id)
        it = getItemType(item)
        "<img src=\"/images/icons/icon_#{@itemType.title.downcase}.png\" title=\"#{it}\" alt=\"#{it}\"/> #{item.title}"
      when "User"
        user = User.find(self.receiverable_id)
        title = user.login
        "<img src=\"/images/icons/icon_user.png\" title=\"#{title}\" alt=\"#{title}\"/> #{title}"
      end
    end
  end
  
  def getReceiverType
    if self.receiverable_id && self.receiverable_type
      type = self.receiverable_type.to_s
      case type
      when "Item"
        Item.find(receiverable_id)
      when "User"
        User.find(receiverable_id)
      end
    end
  end
  
  private
  
  def getItemType(item)
    @itemType = ItemType.find(item.item_type_id)
    @itemType.localized_title
  end
  
end
