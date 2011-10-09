class CreateTransferOptions < ActiveRecord::Migration
  def self.up
    create_table :transfer_options do |t|
      t.string :title
      t.text  :description
      t.integer :item_id

      t.timestamps
    end
  end

  def self.down
    drop_table :transfer_options
  end
end
