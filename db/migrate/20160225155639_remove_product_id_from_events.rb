class RemoveProductIdFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :product_id, :integer
  end
end
