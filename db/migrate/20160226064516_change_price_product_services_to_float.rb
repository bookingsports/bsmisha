class ChangePriceProductServicesToFloat < ActiveRecord::Migration
  def change
    change_column :product_services, :price, :float
  end
end
