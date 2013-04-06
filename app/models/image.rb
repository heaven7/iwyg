class Image < ActiveRecord::Base
  
  attr_accessible :image, :imageable_id, :imageable_type,
                  :image_file_name, :image_content_type, :image_file_size,
                  :created_at, :image_updated_at, :updated_at

  has_attached_file :image, :styles => { :micro => "25x25#", 
                                         :tiny => "50x50#", 
                                         :small => "150x150#", 
                                         :medium => "300x300#", 
                                         :big => "500x500#"},
                            :default_url => 'global/avatar_dummy_profile.png'

  belongs_to :imageable, :polymorphic => true  
  before_post_process :image?

  has_one :custom, :as => :customable

	acts_as_likeable
  
#  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 2.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  def image?
   !(image_content_type =~ /^image.*/).nil?
  end

end
