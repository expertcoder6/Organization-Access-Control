class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :age, :integer
  end
end
