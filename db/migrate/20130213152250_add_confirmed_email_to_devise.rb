class AddConfirmedEmailToDevise < ActiveRecord::Migration
  def self.up
    add_column :users, :unconfirmed_email, :string		
    User.update_all(:confirmed_at => Time.now)
  end
  def self.down
    remove_column :users, :unconfirmed_email
  end
end
