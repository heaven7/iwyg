class AddGeoSpatialDataToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :latlon, :point, :geographic => true
  end

	def self.down
    remove_column :locations, :latlon
	end
end
