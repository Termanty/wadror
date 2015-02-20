class AddAccessDeniedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :access_denied, :boolean
  end
end
