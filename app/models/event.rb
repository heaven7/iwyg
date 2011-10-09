class Event < ActiveRecord::Base

  belongs_to :eventable, :polymorphic => true
  
  
  attr_accessible :from, :till, :eventable_id, :eventable_type, :ping_id, :user_id, :description,
                  :created_at, :updated_at, :status
  
  validates_presence_of :from, :if => :till
  validates_datetime :from, :on_or_after => lambda { Date.today }, :if => :from
  validates_datetime :till, :on_or_after => lambda { Date.today }, :if => :till
  validates_datetime :till, :on_or_after => lambda { :from }, :if => :from && :till
  
  scope :open, :conditions => { :status => 1 }
  scope :not_closed, :conditions => "status < 4"
  scope :accepted, :conditions => { :status => 2 }
  scope :declined, :conditions => { :status => 3 }
  scope :closed, :conditions => { :status => 4 }
        
  def exists?
    Event.find_by_eventable_id_and_eventable_type_and_user_id(self.eventable_id, self.eventable_type, self.user_id)
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
  
  def owner
    User.find(self.user_id) if self.user_id
  end
  
  def ping
    Ping.find(self.ping_id) if self.ping_id
  end
  
  def item
    Item.find(self.eventable_id) if self.eventable_type.to_s == "Item"
  end
  
end
