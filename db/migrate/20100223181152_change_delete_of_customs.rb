class ChangeDeleteOfCustoms < ActiveRecord::Migration
  def self.up
    rename_column :customs, :delete, :deleted
  end

  def self.down
    rename_column :customs, :deleted, :delete
  end
end
