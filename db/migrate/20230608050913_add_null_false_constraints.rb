class AddNullFalseConstraints < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:users, :provider, false)
    change_column_null(:users, :uid, false)
    change_column_null(:users, :username, false)
    change_column_null(:users, :access_token, false)
    change_column_null(:users, :expiry, false)
    change_column_null(:posts, :title, false)
    change_column_null(:posts, :content, false)
    change_column_null(:comments, :body, false)
  end
end
