class AddMerchantIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :merchant_id, :string
  end
end
