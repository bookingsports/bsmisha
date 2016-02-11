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

  def name
    "Снятие #{amount} рублей #{wallet_id.present? ? "с кошелька №" + wallet_id.to_s : ""}"
  end
end
