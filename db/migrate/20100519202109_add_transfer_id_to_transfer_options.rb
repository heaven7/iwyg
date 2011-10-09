class AddTransferIdToTransferOptions < ActiveRecord::Migration
  def self.up
    add_column :transfer_options, :transfer_id, :integer
  end

  def self.down
    remove_column :transfer_options, :transfer_id
  end
end
