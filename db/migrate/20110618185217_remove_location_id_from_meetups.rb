class RemoveLocationIdFromMeetups < ActiveRecord::Migration
  def self.up
    remove_column :meetups, :location_id
  end

  def self.down
    add_column :meetups, :location_id, :integer
  end
end
