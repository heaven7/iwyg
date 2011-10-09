class AddCreatedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :created_at, :datetime
  end

  def self.down
    remove_column :users, :created_at
  end
end
