class AddGeoSpatialDataToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :latlon, :point, :geographic => true
  end
end
