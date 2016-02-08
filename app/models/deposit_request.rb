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
  has_paper_trail
  
  belongs_to :wallet
  composed_of :data, class_name: "DepositRequestData", mapping: [%w(id order_id), %w(amount amount)]
  has_many :deposit_responses

  enum status: [:pending, :success, :failure]

  after_initialize :set_pending, if: :new_record?

  def set_pending
    self.status = :pending
  end
end
