class AddPingIdToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :ping_id, :integer
  end

  def self.down
    remove_column :events, :ping_id
  end
end
