class AddVisibleForToCustoms < ActiveRecord::Migration
  def change
    add_column :customs, :visible_for, :text
  end
end
