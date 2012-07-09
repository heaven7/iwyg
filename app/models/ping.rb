class Ping < ActiveRecord::Base
  belongs_to :pingable, :polymorphic => true
  has_many :comments, :as => :commentable

  attr_accessible :body, :user_id, :pingable_type, :pingable_id, :status, 
                  :created_at, :updated_at, :accepted_at, :status, :follow


  acts_as_followable
  has_associated_audits
  acts_as_audited
  acts_as_paranoid

  scope :open, :conditions => { :status => 1 }
  scope :not_closed, :conditions => "status < 4"
  scope :accepted, :conditions => { :status => 2 }
  scope :declined, :conditions => { :status => 3 }
  scope :closed, :conditions => { :status => 4 }
  scope :created_at_desc, order("pings.created_at DESC")

  scope :user, where("pingable_type = ?", "User")
  scope :group, where("pingable_type = ?", "Group")
  scope :project, where("pingable_type = ?", "Project")
          
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
  
  def not_closed?
    self.status < 4
  end
  
  def item
    Item.find(self.pingable_id) if self.pingable_type == "Item"
  end

  def user
    User.find(self.pingable_id) if self.pingable_type == "User"
  end

  def group
    Group.find(self.pingable_id) if self.pingable_type == "Group"
  end

  def project
    Project.find(self.pingable_id) if self.pingable_type == "Project"
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
    if User.exists?(self.user_id)
      User.find(self.user_id)
    end
  end
  
  def owner?
    if self.owner
      true
    else
      false
    end
  end
  
  def pingedOn?
    type = self.pingable_type.to_s
    case type
    when "Item"
      item = Item.find(pingable_id)
      itemtype = ItemType.find(item.item_type_id).title
      image = "<img src=\"/images/icons/icon_#{itemtype}.png\" title=\"#{I18n.t("#{itemtype}.singular")}\"/>"
      title = item.title
    when "User"
      user = User.find(pingable_id)
      image = "<img src=\"/images/icons/icon_user.png\" title=\"#{I18n.t("user.singular")}\"/>"
      title = user.login
    when "Group"
      group = Group.find(pingable_id)
      title = group.title
      image = "<img src=\"/images/icons/icon_group.png\" title =\"#{I18n.t("group.singular")}\" />"
    end
    image + "&nbsp;" + title
  end
  
end
