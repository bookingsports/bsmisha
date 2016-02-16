class AddUuidToDepositRequests < ActiveRecord::Migration
  def change
    add_column :deposit_requests, :uuid, :string
  end
end
