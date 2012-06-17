class AddSlugToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :slug, :string
#    add_index :groups, :slug
  end

  def self.down
    remove_column :groups, :slug
#    remove_index :groups, :slug
  end
end
