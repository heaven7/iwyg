class ChangeStatusOfItems < ActiveRecord::Migration
  def self.up
    remove_column :items, :status
    add_column :items, :status, :integer, :default => 1
  end

  def self.down
    remove_column :items, :status
    add_column :items, :status, :integer
  end
end
