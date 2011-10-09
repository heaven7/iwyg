class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :title
      t.text :description
      t.integer :status
      t.integer :category
      t.integer :user_id
      t.boolean :need, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
