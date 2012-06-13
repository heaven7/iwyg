class MakeMeetupsParanoid < ActiveRecord::Migration
  def self.up
    add_column :meetups, :deleted_at, :datetime
  end

  def self.down
    remove_column :meetups, :deleted_at
  end
end
