class AddProviderToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :provider, :string
  end
end
