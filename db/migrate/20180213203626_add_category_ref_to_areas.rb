class AddCategoryRefToAreas < ActiveRecord::Migration
  def change
    add_reference :areas, :category, index: true, foreign_key: true
  end
end
