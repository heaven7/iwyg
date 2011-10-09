class Custom < ActiveRecord::Base
  belongs_to :messages
  belongs_to :customable, :polymorphic => true
  
  
end
