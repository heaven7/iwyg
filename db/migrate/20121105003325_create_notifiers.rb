class CreateNotifiers < ActiveRecord::Migration
  def change
    create_table :notifiers do |t|
      t.integer :user_id
      t.integer :notifyable_id
      t.string :notifyable_type

      t.timestamps
    end
  end
end
