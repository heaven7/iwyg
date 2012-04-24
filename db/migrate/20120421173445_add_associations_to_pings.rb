class AddAssociationsToPings < ActiveRecord::Migration
  def self.up
    add_column :pings, :associated_id, :integer
    add_column :pings, :associated_type, :string
  end

  def self.down
    remove_column :pings, :associated_type
    remove_column :pings, :associated_id
  end
end
