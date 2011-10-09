class Account < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  
  scope :taken, :conditions => {:has_taken => 1}
  scope :given, :conditions => {:has_taken => 0}
end
