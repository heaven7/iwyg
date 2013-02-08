class Notification < ActiveRecord::Base
  attr_accessible :description, :is_read, :notifiable_id, :notifiable_type, :receiver, :sender, :receiver_id, :sender_id, :title
  belongs_to :receiver, :class_name => "User"
  belongs_to :sender, :class_name => "User"
  belongs_to :notifiable, :polymorphic => true
  
	default_scope :limit => 5, :order => 'created_at DESC'
  scope :unread, where(:is_read => false)

  validates_presence_of :notifiable_id, :notifiable_type
	validate :user_does_not_already_have_this_notification, :on => :create
  
	
  def user_does_not_already_have_this_notification
    existing_notification = Notification.find_by_receiver_id_and_notifiable_id_and_notifiable_type(receiver_id, notifiable_id, notifiable_type)
    errors.add(:base, "You have already received this notification.") if (existing_notification && existing_notification.created_at > (DateTime.now - 1.day))
  end

	# sends css-class to view
	def is_read_css
		self.is_read == false ? "unread" : "read"
	end
end
