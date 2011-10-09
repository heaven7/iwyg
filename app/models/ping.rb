class Ping < ActiveRecord::Base
  belongs_to :pingable, :polymorphic => true
  has_many :comments, :as => :commentable

  attr_accessible :body, :user_id, :pingable_type, :pingable_id, :status, :created_at, :updated_at, :accepted_at, :status

  scope :open, :conditions => { :status => 1 }
  scope :not_closed, :conditions => "status < 4"
  scope :accepted, :conditions => { :status => 2 }
  scope :declined, :conditions => { :status => 3 }
  scope :closed, :conditions => { :status => 4 }

          
  def exists?
   not Ping.find_by_pingable_id_and_pingable_type_and_user_id(self.pingable_id, self.pingable_type, self.user_id).nil?
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
    Item.find(self.pingable_id) if self.pingable_type == "Item"
  end
  
  def statusTitle
    case self.status.to_i
    when 1
      "opened"
    when 2
      "accepted"
    when 3
      "declined"
    when 4
      "closed"
    end
  end
  
  def owner
    User.find(self.user_id)
  end
  
  def owner?
    self.owner == @current_user
  end
  
  def pingedOn?
    type = self.pingable_type.to_s
    case type
    when "Item"
      item = Item.find(pingable_id)
      itemtype = ItemType.find(item.item_type_id).title
      image = "<img src=\"/images/icons/icon_#{itemtype}.png\" title=\"#{itemtype.humanize}\"/>"
      title = item.title
    when "Transfer"
      transfer = Transfer.find(pingable_id)
      image = "<img src=\"/images/icons/icon_transfer.png\" title =\"Transfer\" />"
      title = Item.find(transfer.transferable_id).title
    end
    image + "&nbsp;" + title
  end
  
end
