class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :ancestry
      t.string :slug
      t.string :icon
      t.integer :position

      t.timestamps null: false
    end

    add_index :categories, :ancestry
  end
end
