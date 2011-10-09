class AddAvailabilityToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :from, :datetime
    add_column :items, :till, :datetime
  end

  def self.down
    remove_column :items, :till
    remove_column :items, :from
  end
end
