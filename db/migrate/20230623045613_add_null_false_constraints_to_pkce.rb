class AddNullFalseConstraintsToPkce < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:pkces, :state, false)
    change_column_null(:pkces, :code_verifier, false)
  end
end
