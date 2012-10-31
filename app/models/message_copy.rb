class MessageCopy < ActiveRecord::Base
  belongs_to :message
  belongs_to :recipient, :class_name => "User" 
  belongs_to :folder
  has_one :custom, :as => :customable
  scope :undeleted, :conditions => { :deleted => nil }
  scope :unread, :conditions => { :read => false }
  delegate :deleted, :to => :custom
  delegate :author, :subject, :body, :recipients, :to => :message

end
