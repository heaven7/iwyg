class PopulateSettingsForItems < ActiveRecord::Migration
  def up
		Item.all.each do |i|
			i.settings.visible_for = 'all'
		end 
  end

  def down
  end
end
