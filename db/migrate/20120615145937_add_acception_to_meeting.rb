class AddAcceptionToMeeting < ActiveRecord::Migration
  def self.up
    add_column :meetings, :accepted, :boolean
    add_column :meetings, :accepted_at, :datetime
  end

  def self.down
    remove_column :meetings, :accepted_at
    remove_column :meetings, :accepted
  end
end
