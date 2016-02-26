class ChangePriceToFloat < ActiveRecord::Migration
  def change
    change_column :products, :price, :float
    change_column :products, :change_price, :float
  end
end
