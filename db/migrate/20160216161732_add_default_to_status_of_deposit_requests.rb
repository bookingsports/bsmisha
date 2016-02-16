class AddDefaultToStatusOfDepositRequests < ActiveRecord::Migration
  def change
    change_column :deposit_requests, :status, :integer, default: 0
  end
end
