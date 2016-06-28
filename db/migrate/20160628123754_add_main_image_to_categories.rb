class AddMainImageToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :main_image, :string
  end
end
