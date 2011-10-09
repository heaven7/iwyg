class AddReadToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :read, :boolean
  end

  def self.down
    remove_column :messages, :read
  end
end
