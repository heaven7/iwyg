require 'active_record/fixtures'
class LoadItemStatusesData < ActiveRecord::Migration
  def self.up
    down
    directory = File.join(File.dirname(__FILE__), "data")
    Fixtures.create_fixtures(directory, "item_statuses")
  end

  def self.down
    ItemStatus.delete_all
  end
end
