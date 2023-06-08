class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :provider
      t.string :uid
      t.string :username
      t.string :email
      t.string :access_token
      t.datetime :expiry

      t.timestamps
    end
  end
end
