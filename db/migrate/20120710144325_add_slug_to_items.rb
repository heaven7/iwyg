class AddSlugToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :slug, :string
    add_index :items, :slug
  end

  def self.down
    remove_column :items, :slug
    remove_index :items, :slug
  end
end
