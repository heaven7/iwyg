class ChangeItemIdOfTransferOptions < ActiveRecord::Migration
  def self.up
    rename_column :transfer_options, :item_id, :item_type_id
    remove_column :transfer_options, :transfer_id
  end

  def self.down
    rename_column :transfer_options, :item_type_id, :item_id
    add_column :transfer_options, :transfer_id, :integer
  end
end
