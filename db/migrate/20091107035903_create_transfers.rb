class CreateTransfers < ActiveRecord::Migration
  def self.up
    create_table :transfers do |t|
      t.integer :transferable_id
      t.string :transferable_type
      t.integer :status
      t.integer :user_id
      t.datetime :accepted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :transfers
  end
end
