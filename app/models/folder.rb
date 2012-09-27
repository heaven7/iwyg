class Folder < ActiveRecord::Base
#  acts_as_tree
  belongs_to :user
  has_many :messages, :class_name => "MessageCopy"

  def exists?(user)
 	Folder.where(:title => "Inbox", :user_id => user.id)
  end
end
