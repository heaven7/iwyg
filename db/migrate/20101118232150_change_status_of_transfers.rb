class ChangeStatusOfTransfers < ActiveRecord::Migration
  def self.up
    change_column_default :transfers, :status, 1
  end

  def self.down
    change_column_default :transfers, :status, nil
  end
end
