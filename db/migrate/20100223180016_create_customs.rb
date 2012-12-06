class CreateCustoms < ActiveRecord::Migration
  def self.up
    create_table :customs do |t|
      t.integer :customable_id
      t.string :customable_type
      t.boolean :delete
      t.boolean :visible, :default => true
      t.boolean :enable, :default => true
      t.string :background

      t.timestamps
    end
  end

  def self.down
    drop_table :customs
  end
end
