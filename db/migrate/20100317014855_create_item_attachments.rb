class CreateItemAttachments < ActiveRecord::Migration
  def self.up
    create_table :item_attachments do |t|
      t.integer :parent_id
      t.integer :item_id

      t.timestamps
    end
  end

  def self.down
    drop_table :item_attachments
  end
end
