# == Schema Information
#
# Table name: deposits
#
#  id         :integer          not null, primary key
#  wallet_id  :integer
#  status     :integer
#  amount     :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Deposit < ActiveRecord::Base
  include DepositConcern

  has_paper_trail

  belongs_to :wallet, required: true

  def name
    "Зачисление #{amount.to_i} рублей на кошелек пользователя #{wallet.user.name}"
  end
end
