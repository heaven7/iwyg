class PopulateSettingsForPings < ActiveRecord::Migration
  def up
		Ping.all.each do |p|
			p.settings.visible_for = 'owner'
		end 
  end

  def down
  end
end
