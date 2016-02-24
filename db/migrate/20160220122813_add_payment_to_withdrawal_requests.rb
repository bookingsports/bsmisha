class AddPaymentToWithdrawalRequests < ActiveRecord::Migration
  def change
    add_column :withdrawal_requests, :payment, :text
  end
end
