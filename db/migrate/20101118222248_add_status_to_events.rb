class AddStatusToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :status, :integer
  end

  def self.down
    remove_column :events, :status
  end
end
