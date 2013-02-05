class AddAccountableToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :accountable_id, :integer
    add_column :accounts, :accountable_type, :string
  end
end
