class AddFieldsToFriendships < ActiveRecord::Migration
  def change
    add_column :friendships, :invitation_id, :integer
    add_column :friendships, :name, :string
    add_column :friendships, :email, :string
    add_column :friendships, :token, :string
    add_column :friendships, :accepted, :boolean
  end
end
