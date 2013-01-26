class AddItemableTypeAndItemableIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :itemable_id, :integer
    add_column :items, :itemable_type, :string
  end
end
