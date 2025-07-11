class AddParentEmailToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :parent_email, :string
    add_column :users, :parent_confirmed, :boolean
  end
end
