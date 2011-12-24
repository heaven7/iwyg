class Group < ActiveRecord::Base
    attr_accessible :user_id, :user_ids, :title, :description

    belongs_to :user

    has_many :users
    has_many :items
end
