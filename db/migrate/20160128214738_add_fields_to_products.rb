class AddFieldsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :opens_at, :datetime
    add_column :products, :closes_at, :datetime
  end
end
