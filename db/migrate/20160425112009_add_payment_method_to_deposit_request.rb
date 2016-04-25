class AddPaymentMethodToDepositRequest < ActiveRecord::Migration
  def change
    add_column :deposit_requests, :payment_method, :int, default: 0
  end
end
