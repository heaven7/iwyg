class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :receiver_id
      t.boolean :is_read, :default => false
      t.string :title
      t.text :description
      t.integer :notifiable_id
      t.string :notifiable_type

      t.timestamps
    end
  end
end
