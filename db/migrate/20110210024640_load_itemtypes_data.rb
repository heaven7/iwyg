require 'active_record/fixtures'
class LoadItemtypesData < ActiveRecord::Migration
  def self.up
    down
    directory = File.join(File.dirname(__FILE__), "data")
    Fixtures.create_fixtures(directory, "item_types")
  end

  def self.down
    ItemType.delete_all
  end
end
