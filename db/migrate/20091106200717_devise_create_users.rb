class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    drop_table :users if self.table_exists?("users")
    create_table(:users) do |t|          
      
      t.string :login
      t.database_authenticatable 
      t.encryptable
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :unlock_token,         :unique => true
  end

  def self.down
    drop_table :users
  end

  def self.table_exists?(name)
    ActiveRecord::Base.connection.tables.include?(name)
  end
  
end
