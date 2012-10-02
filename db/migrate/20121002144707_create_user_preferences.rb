class CreateUserPreferences < ActiveRecord::Migration
  def change
    create_table :user_preferences do |t|
      t.integer :user_id
      t.integer :custom_id
      t.string :language
      t.boolean :active

      t.timestamps
    end
  end
end
