class Custom < ActiveRecord::Base
  belongs_to :messages
  belongs_to :users
  belongs_to :groups
  belongs_to :meetups
  belongs_to :images
  belongs_to :items
  belongs_to :customable, :polymorphic => true
  
  has_many :users
  has_many :groups

	serialize :visible_for

end
