# == Schema Information
#
# Table name: withdrawal_requests
#
#  id         :integer          not null, primary key
#  wallet_id  :integer
#  status     :integer
#  amount     :decimal(8, 2)
#  data       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WithdrawalRequest < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :wallet
  composed_of :request_data, class_name: "WithdrawalRequestData", mapping: [ %w(id order_id), %w(amount amount)]

  validate :amount_no_more_than_can_spend

  enum status: [:pending, :success, :failure]

  def amount_no_more_than_can_spend
    unless wallet.can_spend? amount
      errors.add :base, "Недостаточно средств"
    end
  end
end
