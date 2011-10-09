class AddReadToMessageCopies < ActiveRecord::Migration
  def self.up
    add_column :message_copies, :read, :boolean
  end

  def self.down
    remove_column :message_copies, :read
  end
end
