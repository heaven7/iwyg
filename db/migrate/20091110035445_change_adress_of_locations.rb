class ChangeAdressOfLocations < ActiveRecord::Migration
  def self.up
    rename_column :locations, :adress, :address 
  end

  def self.down
    rename_column :locations, :address, :adress
  end
end
