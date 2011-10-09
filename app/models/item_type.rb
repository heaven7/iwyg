class ItemType < ActiveRecord::Base
  belongs_to :item
  
  def localized_title
    I18n.translate( "#{self.title.downcase}", :count => 1 ).gsub("1 ", "")
  end
end
