class AddIpToSearches < ActiveRecord::Migration
  def self.up
    add_column :searches, :ip, :string
  end

  def self.down
    remove_column :searches, :ip
  end
end
