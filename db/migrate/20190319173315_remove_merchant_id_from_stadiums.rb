class RemoveMerchantIdFromStadiums < ActiveRecord::Migration
  def change
    remove_column :stadiums, :merchant_id, :string
  end
end
