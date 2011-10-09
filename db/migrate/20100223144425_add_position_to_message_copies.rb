class AddPositionToMessageCopies < ActiveRecord::Migration
  def self.up
    add_column :message_copies, :position, :integer
  end

  def self.down
    remove_column :message_copies, :position
  end
end
