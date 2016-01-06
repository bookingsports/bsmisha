class WithdrawalRequest < ActiveRecord::Base
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
