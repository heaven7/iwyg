class AddGroupIdToItemAttachments < ActiveRecord::Migration
  def self.up
    add_column :item_attachments, :group_id, :integer
  end

  def self.down
    remove_column :item_attachments, :group_id
  end
end
