# == Schema Information
#
# Table name: withdrawals
#
#  id         :integer          not null, primary key
#  wallet_id  :integer
#  status     :integer
#  amount     :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Withdrawal < ActiveRecord::Base
  include WithdrawalConcern
  has_paper_trail

  belongs_to :wallet

  after_save :update_wallet_cache
  after_destroy :update_wallet_cache

  def update_wallet_cache
    wallet.update_total_cache
  end

  def name
    "Снятие #{amount} рублей #{wallet_id.present? ? "с кошелька №" + wallet_id.to_s : ""}"
  end
end
