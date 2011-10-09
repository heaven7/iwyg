class ChangeUserdetails < ActiveRecord::Migration
  def self.up
    remove_column :userdetails, :aims
    remove_column :userdetails, :likes
    remove_column :userdetails, :nolikes
  end

  def self.down
    add_column :userdetails, :aims, :string
    add_column :userdetails, :likes, :string
    add_column :userdetails, :nolikes, :string
  end
end
