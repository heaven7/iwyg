class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :sender_id
      t.string :username
      t.string :password
      t.text :emails
      t.text :invitationmessage

      t.timestamps
    end
  end
end
