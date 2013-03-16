class UpdateLatLonOfLocations < ActiveRecord::Migration
  def up
		Location.connection.execute("update locations set latlon = GeomFromText(CONCAT('POINT(',lat,' ',lng,')'), 6422)")
  end

  def down
  end
end
class AddGeoSpatialDataToLocations < ActiveRecord::Migration
end
