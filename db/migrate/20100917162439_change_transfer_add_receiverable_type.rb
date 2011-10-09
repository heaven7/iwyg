class ChangeTransferAddReceiverableType < ActiveRecord::Migration
  def self.up
    add_column :transfers, :receiverable_type, :string
    rename_column :transfers, :receiver, :receiverable_id
  end

  def self.down
    remove_column :transfers, :receiverable_type
    rename_column :transfers, :receiverable_id, :receiver
  end
end
