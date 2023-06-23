class CreatePkces < ActiveRecord::Migration[7.0]
  def change
    create_table :pkces do |t|
      t.string :state
      t.string :code_verifier

      t.timestamps
    end
    add_index :pkces, :state
  end
end
