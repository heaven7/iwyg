class AddLanguageToUserDetails < ActiveRecord::Migration
  def self.up
    add_column :userdetails, :language, :string
  end

  def self.down
    remove_column :userdetails, :language
  end
end
