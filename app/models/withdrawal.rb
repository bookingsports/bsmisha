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
  belongs_to :wallet
end
