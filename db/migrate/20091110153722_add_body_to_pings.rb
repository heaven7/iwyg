class AddBodyToPings < ActiveRecord::Migration
  def self.up
    add_column :pings, :body, :text
  end

  def self.down
    remove_column :pings, :body
  end
end
