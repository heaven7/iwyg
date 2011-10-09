class AddPingerToTransfers < ActiveRecord::Migration
  def self.up
    add_column :transfers, :pinger, :integer
  end

  def self.down
    remove_column :transfers, :pinger
  end
end
