class Notifier < ActiveRecord::Base
  attr_accessible :notifyable_id, :notifyable_type, :user_id

	belongs_to :user

	validates :user_id, :notifyable_id, :notifyable_type, presence: true
end
