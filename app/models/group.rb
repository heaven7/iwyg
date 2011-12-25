class Group < ActiveRecord::Base
    attr_accessible :user_id, :user_ids, :title, :description, :tag_list, :tag_tokens

    attr_reader :tag_tokens

    belongs_to :user


    acts_as_taggable_on :tags

    has_many :users
    has_many :item_attachments, :dependent => :destroy
    accepts_nested_attributes_for :item_attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:attachment_id].blank? } 
  
    def owner
      User.find(self.user_id)
    end

    def owner?
      self.owner == @current_user
    end
end
