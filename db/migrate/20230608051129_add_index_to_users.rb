class AddIndexToUsers < ActiveRecord::Migration[7.0]
  def change
    add_index(:users, [:provider, :uid], unique: true, name: 'by_provider_uid')
  end
end
