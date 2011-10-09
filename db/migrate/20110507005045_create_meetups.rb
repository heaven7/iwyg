class CreateMeetups < ActiveRecord::Migration
  def self.up
    create_table :meetups do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.integer :location_id
      t.integer :event_id
      t.integer :owner_id
      t.string :ownertype
      
      t.timestamps
    end
  end

  def self.down
    drop_table :meetups
  end
end
