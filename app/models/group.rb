class Group < ActiveRecord::Base
    attr_accessible :user_id, :user_ids, :title, :description, :tag_list, :tag_tokens, :locations, :images, :users,
                    :locations_attributes

    attr_reader :tag_tokens

    belongs_to :user


    acts_as_taggable_on :tags

    has_many :users
    has_many :locations, :as => :locatable, :dependent => :destroy
    accepts_nested_attributes_for :locations, :allow_destroy => true, :reject_if => proc { |attrs| attrs.blank? }
    has_many :images, :dependent => :destroy
    accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => proc { |attrs| attrs.blank? }
    has_many :item_attachments, :dependent => :destroy
    accepts_nested_attributes_for :item_attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:attachment_id].blank? }
  
    def owner
      User.find(self.user_id) if self.user_id
    end

    def owner?
      if self.user_id
        true
      else
        false
      end
    end

    def tag_list_name
      self.tag_list if tag_list
    end

    def tag_list_name=(name)
      self.tag_list = Tag.find_or_create_by_name(name) unless name.blank?
    end
end
