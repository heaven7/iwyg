class ChangeNameOfMeasures < ActiveRecord::Migration
  def self.up
    rename_column :measures, :name, :title
  end

  def self.down
    rename_column :measures, :title, :name
  end
end
