class AddGMapsToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :gmaps, :boolean
  end

  def self.down
    remove_column :locations, :gmaps
  end
end
