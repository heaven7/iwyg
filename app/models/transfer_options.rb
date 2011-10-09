class TransferOptions < ActiveRecord::Base
  belongs_to :transfer
  
  # scopes
  scope :good, :conditions => {:item_type_id => 1}
  scope :service, :conditions => {:item_type_id => 2}
  scope :transport, :conditions => {:item_type_id => 3}
  scope :idea, :conditions => {:item_type_id => 4}
  scope :sharingpoint, :conditions => {:item_type_id => 5}
end
