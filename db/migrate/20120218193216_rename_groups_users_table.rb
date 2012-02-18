class RenameGroupsUsersTable < ActiveRecord::Migration
  def self.up
    rename_table :groups_users, :groupings
  end

  def self.down
    rename_table :groupings, :groups_users
  end
end
