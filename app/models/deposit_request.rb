class DepositRequest < ActiveRecord::Base
  belongs_to :wallet
  composed_of :data, class_name: "DepositRequestData", mapping: [%w(id order_id), %w(amount amount)]
  has_many :deposit_responses

  enum status: [:pending, :success, :failure]

  after_initialize :set_pending, if: :new_record?

  def set_pending
    self.status = :pending
  end
end
