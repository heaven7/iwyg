class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
      t.integer :meetup_id
      t.integer :user_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :meetings
  end
end
