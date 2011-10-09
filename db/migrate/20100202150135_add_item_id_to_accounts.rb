class AddItemIdToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :item_id, :integer
  end

  def self.down
    remove_column :accounts, :item_id
  end
end
