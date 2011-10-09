class ChangeParentIdOfItemAttachments < ActiveRecord::Migration
  def self.up
    rename_column :item_attachments, :parent_id, :attachment_id
  end

  def self.down
    rename_column :item_attachments, :attachment_id, :parent_id
  end
end
