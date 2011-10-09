class ChangeStatusOfEvents < ActiveRecord::Migration
  def self.up
    change_column_default :events, :status, 1
  end

  def self.down
    change_column_default :events, :status, nil
  end
end
