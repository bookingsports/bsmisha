# == Schema Information
#
# Table name: wallets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Wallet < ActiveRecord::Base
  include WalletConcern
  has_paper_trail

  belongs_to :user
  has_many :deposits, dependent: :destroy
  has_many :deposit_requests, dependent: :destroy
  has_many :withdrawals, dependent: :destroy
  has_many :withdrawal_requests, dependent: :destroy

  def deposit_with_tax_deduction!(amount)
    deposit! amount - tax_for(amount)
    deduct_tax(amount)
  end

  def deposit!(amount)
    deposits.create! amount: amount
  end

  def withdraw!(amount)
    if can_spend? amount
      withdrawals.create! amount: amount
    else
      raise "Недостаточно средств"
    end
  end

  def total
    deposits.sum(:amount) - withdrawals.sum(:amount) + deposit_requests.success.sum(:amount) - withdrawal_requests.success.sum(:amount)
  end

  def can_spend?(amount)
    total - amount >= 0
  end

  def tax_for(amount)
    amount.to_f * Option.current.tax / 100
  end

  private

    def deduct_tax(amount)
      AdminWallet.find.deposit!(tax_for(amount))
    end
end
