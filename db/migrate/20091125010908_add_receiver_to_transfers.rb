class AddReceiverToTransfers < ActiveRecord::Migration
  def self.up
    add_column :transfers, :receiver, :integer
  end

  def self.down
    remove_column :transfers, :receiver
  end
end
