class AddAmountToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :amount, :float
    add_column :items, :measure_id, :integer
  end

  def self.down
    remove_column :items, :measure_id
    remove_column :items, :amount
  end
end
