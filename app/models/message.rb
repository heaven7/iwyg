class Message < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  has_many :message_copies
  has_many :recipients, :through => :message_copies
  has_one :custom, :as => :customable
  before_create :prepare_copies

  delegate :deleted, :to => :custom
  scope :undeleted, :conditions => { :deleted => nil }
  
  attr_accessor  :to # array of people to send to
  attr_accessible :subject, :body, :to, :read
  
  validates_presence_of :body, :to

  def build_message
    self.custom = Custom.new
  end
  
  def prepare_copies
    return if to.blank?
    recipient = to
    recipient = User.find(recipient)
    m = message_copies.build(:recipient => recipient, :folder => recipient.inbox, :created_at => Time.now)
    m.custom = Custom.new
    #to.each do |recipient|
    #  recipient = User.find(recipient)
    #  m = message_copies.build(:recipient => recipient, :folder => recipient.inbox)
    #  m.custom = Custom.new
    #end
    true
  end
end
