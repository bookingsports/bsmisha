class RemoveJoinTableProductsEvents < ActiveRecord::Migration
  def change
    drop_table :events_products
  end
end
