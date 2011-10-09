class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.integer :locatable_id
      t.string :locatable_type
      t.integer :user_id
      t.string :adress
      t.string :city
      t.string :state
      t.string :country
      t.string :zip
      t.decimal :lat, :precision => 15, :scale => 12
      t.decimal :lng, :precision => 15, :scale => 12

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
