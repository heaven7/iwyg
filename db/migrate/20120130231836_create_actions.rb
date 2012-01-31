class CreateActions < ActiveRecord::Migration
  def self.up
    create_table :actions do |t|
      t.integer :watchable_id
      t.string :watchable_type
      t.string :type
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :actions
  end
end
