class AddMerchantIdToStadiums < ActiveRecord::Migration
  def change
    add_column :stadiums, :merchant_id, :string
  end
end
