class Image < ActiveRecord::Base
  has_attached_file :image, :styles => { :micro => "25x25#", 
                                         :tiny => "50x50#", 
                                         :small => "150x150#", 
                                         :medium => "300x300#", 
                                         :big => "500x500#"},
                            :default_url => 'global/avatar_dummy_profile.png'
  # for paperclip (polymorphic)
  acts_as_polymorphic_paperclip 
 # before_post_process :image?

  belongs_to :imageable, :polymorphic => true
  acts_as_taggable_on :tags
    
#  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 2.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  def image?
   !(image_content_type =~ /^image.*/).nil?
  end

end
