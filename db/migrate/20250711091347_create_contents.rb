class CreateContents < ActiveRecord::Migration[7.0]
  def change
    create_table :contents do |t|
      t.string :title
      t.text :description
      t.integer :age_group
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
