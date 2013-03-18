class Message < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  has_many :message_copies
  has_many :recipients, :through => :message_copies
  has_one :custom, :as => :customable
  after_create :prepare_copies

  delegate :deleted, :to => :custom
  scope :undeleted, :conditions => { :deleted => nil }
	is_impressionable
  
  attr_accessor  :to # array of people to send to
  attr_accessible :subject, :body, :to, :read
  
	validates_presence_of :to, :body  

  
	def prepare_copies
    return if to.blank?
		@recipients = []
		if not to.is_a?(Array) and to.include? ","
			@recipients = to.gsub(/\s+/, "").split(',')
		else
			@recipients << to
    end
		@recipients.each do |recipient|
      user = User.find(recipient)
      m = MessageCopy.new(:recipient => user, :folder => user.inbox, :created_at => Time.now, :message_id => self.id)
      m.custom = Custom.new
    	m.save
    end
    true
  end
end
