class CreatePings < ActiveRecord::Migration
  def self.up
    create_table :pings do |t|
      t.integer :pingable_id
      t.string :pingable_type
      t.integer :status
      t.integer :user_id
      t.datetime :accepted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :pings
  end
end
