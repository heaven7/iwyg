class CreateGroupings < ActiveRecord::Migration
  def self.up
    create_table :groupings do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :owner_id
			t.boolean :accepted
			t.datetime :accepted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :groupings
  end
end
