class PopulateSettingsForGroups < ActiveRecord::Migration
  def up
	Group.all.each do |i|
		i.settings.visible_for = 'all'
	end 
  end

  def down
  end
end
