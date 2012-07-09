class MakePingsParanoid < ActiveRecord::Migration
  def self.up
    add_column :pings, :deleted_at, :datetime
  end

  def self.down
    remove_column :pings, :deleted_at
  end
end
