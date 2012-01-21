class ItemAttachment < ActiveRecord::Base

  belongs_to :item
  belongs_to :group
  belongs_to :meetup
  belongs_to :attachment, :class_name => "Item", :foreign_key => :attachment_id
  
  def item
    Item.find(self.attachment_id) if self.attachment_id
  end
  
end
