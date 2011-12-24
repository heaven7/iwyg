class Group < ActiveRecord::Base
    attr_accessible :user_id, :user_ids, :title, :description

    belongs_to :user

    has_many :users
    has_many :items
    has_many :images, :as => :imageable, :dependent => :destroy
    accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }  
    has_many :items
    accepts_nested_attributes_for :items, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }  
    has_many :items_needed,
           :through => 'Items',
           :conditions => {:need => true}
    has_many :items_offered,
           :class_name => 'Item',
           :conditions => {:need => false}
    has_many :items_taken,
           :source => :item,
           :through => :accounts,
           :foreign_key => "user_id",
           :conditions => {:need => false}
    has_many :items_given,
           :source => :item,
           :through => :accounts,
           :foreign_key => "user_id",
           :conditions => {:need => true}     
    has_many :item_attachments, :dependent => :destroy
    accepts_nested_attributes_for :item_attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:attachment_id].blank? } 
  
    def owner
      User.find(self.user_id)
    end

    def owner?
      self.owner == @current_user
    end
end
