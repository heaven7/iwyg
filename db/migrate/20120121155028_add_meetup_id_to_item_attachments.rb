class AddMeetupIdToItemAttachments < ActiveRecord::Migration
  def self.up
    add_column :item_attachments, :meetup_id, :integer
  end

  def self.down
    remove_column :item_attachments, :meetup_id
  end
end
