class ChangeDefaultForStatusForWithdrawalRequest < ActiveRecord::Migration
  def change
    change_column :withdrawal_requests, :status, :integer, default: 0
  end
end
