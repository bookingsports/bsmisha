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
#  uuid       :string
#

class DepositRequest < ActiveRecord::Base
  include DepositRequestConcern

  has_paper_trail

  belongs_to :wallet
  composed_of :data, class_name: 'DepositRequestData', mapping: [%w(uuid order_id), %w(amount amount)]
  has_many :deposit_responses

  validates :amount, numericality: { greater_than: 0, less_than_or_equal_to: Rails.application.secrets.amount_limit }

  before_save { self.uuid = SecureRandom.uuid }

  enum status: [:pending, :success, :failure]

  def name
    "Запрос депозита №#{id} #{wallet_id.present? ? 'кошелька №' + wallet.id.to_s : ''}"
  end
end
