class RemoveMerchantIdFromCoaches < ActiveRecord::Migration
  def change
    remove_column :coaches, :merchant_id, :string
  end
end
