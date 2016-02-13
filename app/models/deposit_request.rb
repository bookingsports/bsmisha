# == Schema Information
#
# Table name: deposit_requests
#
#  id         :integer          not null, primary key
#  wallet_id  :integer
#  status     :integer
#  amount     :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  data       :text
#

class DepositRequest < ActiveRecord::Base
  include DepositRequestConcern
  extend Enumerize

  has_paper_trail

  belongs_to :wallet
  composed_of :data, class_name: "DepositRequestData", mapping: [%w(id order_id), %w(amount amount)]
  has_many :deposit_responses

  enumerize :status, in: [:pending, :success, :failure]

  # Backwards compatibility for enum. Remove once fixed
  scope :success, -> { where(status: :success) }

  after_initialize :set_pending, if: :new_record?

  def name
    "Запрос депозита №#{id} #{wallet_id.present? ? "кошелька №" + wallet.id.to_s : ""}"
  end

  def set_pending
    self.status = :pending
  end
end
