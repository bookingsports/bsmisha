class AddMerchantIdToCoaches < ActiveRecord::Migration
  def change
    add_column :coaches, :merchant_id, :string
  end
end
