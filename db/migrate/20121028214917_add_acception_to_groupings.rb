class AddAcceptionToGroupings < ActiveRecord::Migration
  def change
    add_column :groupings, :accepted, :boolean
    add_column :groupings, :accepted_at, :datetime
  end
end
