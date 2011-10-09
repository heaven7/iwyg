class CreateUserdetails < ActiveRecord::Migration
  def self.up
    create_table :userdetails do |t|
      t.integer :user_id
      t.string :firstname
      t.string :lastname
      t.datetime :birthdate
      t.string :occupation
      t.string :company
      t.text :likes
      t.text :nolikes
      t.text :aims

      t.timestamps
    end
  end

  def self.down
    drop_table :userdetails
  end
end
