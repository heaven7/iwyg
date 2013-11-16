class ItemType < ActiveRecord::Base
  belongs_to :item
  
  def localized_title
    I18n.translate( "#{self}.singular").html_safe
  end
end
