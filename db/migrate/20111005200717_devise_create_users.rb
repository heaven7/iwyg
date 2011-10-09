class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|          
      
      
      # column email already exists
      # t.database_authenticatable :null => false 
      t.string :encrypted_password, :null => false, :default => '', :limit => 128
      
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
    # the columns below are manually extracted from devise/schema.rb.
    change_table :users do |t|
    
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40
      t.string :remember_token
      t.datetime :remember_token_expires_at
      t.string :activation_code, :limit => 40
      t.datetime :activated_at
      t.datetime :last_login_at
      
      t.remove :encrypted_password
      t.remove :password_salt
      t.remove :authentication_token
      t.remove :confirmation_token
      t.remove :confirmed_at
      t.remove :confirmation_sent_at
      t.remove :reset_password_token
      t.remove :reset_password_sent_at
      t.remove :remember_token
      t.remove :remember_created_at
      t.remove :sign_in_count
      t.remove :current_sign_in_at
      t.remove :last_sign_in_at
      t.remove :current_sign_in_ip
      t.remove :last_sign_in_ip
      t.remove :failed_attempts
      t.remove :unlock_token
      t.remove :locked_at
      
    end
  end
  
end
